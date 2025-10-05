from flask import Flask, jsonify, request
import os
import pymongo
from datetime import datetime

app = Flask(__name__)

# Configuration from environment variables
DB_HOST = os.environ.get('DB_HOST', 'localhost')
DB_PORT = int(os.environ.get('DB_PORT', 27017))
DB_NAME = os.environ.get('DB_NAME', 'userdb')
SECRET_KEY = os.environ.get('SECRET_KEY', 'default-secret')

# In-memory storage for demo (in production, use MongoDB)
users = {}
user_counter = 0

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'user-service'})

@app.route('/users', methods=['GET'])
def get_users():
    return jsonify(list(users.values()))

@app.route('/users', methods=['POST'])
def create_user():
    global user_counter
    data = request.json
    user_counter += 1
    user = {
        'id': user_counter,
        'name': data.get('name'),
        'email': data.get('email'),
        'created_at': datetime.now().isoformat()
    }
    users[user_counter] = user
    return jsonify(user), 201

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = users.get(user_id)
    if user:
        return jsonify(user)
    return jsonify({'error': 'User not found'}), 404

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    if user_id not in users:
        return jsonify({'error': 'User not found'}), 404
    
    data = request.json
    users[user_id].update({
        'name': data.get('name', users[user_id]['name']),
        'email': data.get('email', users[user_id]['email']),
        'updated_at': datetime.now().isoformat()
    })
    return jsonify(users[user_id])

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    if user_id not in users:
        return jsonify({'error': 'User not found'}), 404
    del users[user_id]
    return '', 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)