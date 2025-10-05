from flask import Flask, jsonify, request
import os
import requests
from datetime import datetime

app = Flask(__name__)

# Configuration
USER_SERVICE_URL = os.environ.get('USER_SERVICE_URL', 'http://user-service:5001')
PRODUCT_SERVICE_URL = os.environ.get('PRODUCT_SERVICE_URL', 'http://product-service:5002')
NOTIFICATION_SERVICE_URL = os.environ.get('NOTIFICATION_SERVICE_URL', 'http://notification-service:5004')
SECRET_KEY = os.environ.get('SECRET_KEY', 'default-secret')

# In-memory storage
orders = {}
order_counter = 0

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'order-service'})

@app.route('/orders', methods=['GET'])
def get_orders():
    return jsonify(list(orders.values()))

@app.route('/orders', methods=['POST'])
def create_order():
    global order_counter
    data = request.json
    
    # Validate user exists
    user_id = data.get('user_id')
    try:
        user_response = requests.get(f'{USER_SERVICE_URL}/users/{user_id}')
        if user_response.status_code != 200:
            return jsonify({'error': 'Invalid user'}), 400
    except:
        pass  # In case service is not available
    
    # Validate product exists and has stock
    product_id = data.get('product_id')
    quantity = data.get('quantity', 1)
    try:
        product_response = requests.get(f'{PRODUCT_SERVICE_URL}/products/{product_id}')
        if product_response.status_code != 200:
            return jsonify({'error': 'Invalid product'}), 400
        
        # Update stock
        requests.patch(f'{PRODUCT_SERVICE_URL}/products/{product_id}/stock', 
                      json={'quantity': -quantity})
    except:
        pass  # In case service is not available
    
    order_counter += 1
    order = {
        'id': order_counter,
        'user_id': user_id,
        'product_id': product_id,
        'quantity': quantity,
        'status': 'pending',
        'created_at': datetime.now().isoformat()
    }
    orders[order_counter] = order
    
    # Send notification
    try:
        requests.post(f'{NOTIFICATION_SERVICE_URL}/notifications', 
                     json={
                         'type': 'order_created',
                         'order_id': order_counter,
                         'user_id': user_id
                     })
    except:
        pass  # Notification is not critical
    
    return jsonify(order), 201

@app.route('/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    order = orders.get(order_id)
    if order:
        return jsonify(order)
    return jsonify({'error': 'Order not found'}), 404

@app.route('/orders/<int:order_id>/status', methods=['PATCH'])
def update_order_status(order_id):
    if order_id not in orders:
        return jsonify({'error': 'Order not found'}), 404
    
    data = request.json
    new_status = data.get('status')
    if new_status not in ['pending', 'processing', 'shipped', 'delivered', 'cancelled']:
        return jsonify({'error': 'Invalid status'}), 400
    
    orders[order_id]['status'] = new_status
    orders[order_id]['updated_at'] = datetime.now().isoformat()
    
    # Send notification
    try:
        requests.post(f'{NOTIFICATION_SERVICE_URL}/notifications', 
                     json={
                         'type': 'order_status_changed',
                         'order_id': order_id,
                         'status': new_status
                     })
    except:
        pass
    
    return jsonify(orders[order_id])

@app.route('/orders/user/<int:user_id>', methods=['GET'])
def get_user_orders(user_id):
    user_orders = [order for order in orders.values() if order['user_id'] == user_id]
    return jsonify(user_orders)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003, debug=True)