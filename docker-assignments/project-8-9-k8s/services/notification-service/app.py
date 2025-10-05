from flask import Flask, jsonify, request
import os
from datetime import datetime

app = Flask(__name__)

# Configuration
SMTP_HOST = os.environ.get('SMTP_HOST', 'smtp.gmail.com')
SMTP_PORT = os.environ.get('SMTP_PORT', '587')
SMTP_USER = os.environ.get('SMTP_USER', 'noreply@example.com')
SMTP_PASSWORD = os.environ.get('SMTP_PASSWORD', 'password')

# In-memory storage
notifications = {}
notification_counter = 0

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'notification-service'})

@app.route('/notifications', methods=['GET'])
def get_notifications():
    return jsonify(list(notifications.values()))

@app.route('/notifications', methods=['POST'])
def create_notification():
    global notification_counter
    data = request.json
    
    notification_counter += 1
    notification = {
        'id': notification_counter,
        'type': data.get('type'),
        'recipient': data.get('user_id'),
        'message': generate_message(data),
        'status': 'sent',
        'created_at': datetime.now().isoformat()
    }
    notifications[notification_counter] = notification
    
    # In production, actually send email/SMS here
    print(f"Notification sent: {notification['message']}")
    
    return jsonify(notification), 201

@app.route('/notifications/<int:notification_id>', methods=['GET'])
def get_notification(notification_id):
    notification = notifications.get(notification_id)
    if notification:
        return jsonify(notification)
    return jsonify({'error': 'Notification not found'}), 404

@app.route('/notifications/user/<int:user_id>', methods=['GET'])
def get_user_notifications(user_id):
    user_notifications = [n for n in notifications.values() if n['recipient'] == user_id]
    return jsonify(user_notifications)

def generate_message(data):
    notification_type = data.get('type')
    
    if notification_type == 'order_created':
        return f"Your order #{data.get('order_id')} has been created successfully!"
    elif notification_type == 'order_status_changed':
        return f"Your order #{data.get('order_id')} status has been updated to: {data.get('status')}"
    elif notification_type == 'welcome':
        return f"Welcome to our platform! User ID: {data.get('user_id')}"
    else:
        return "You have a new notification"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5004, debug=True)