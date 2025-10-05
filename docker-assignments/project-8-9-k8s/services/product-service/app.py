from flask import Flask, jsonify, request
import os
from datetime import datetime

app = Flask(__name__)

# Configuration
DB_HOST = os.environ.get('DB_HOST', 'localhost')
SECRET_KEY = os.environ.get('SECRET_KEY', 'default-secret')

# In-memory storage
products = {}
product_counter = 0

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'product-service'})

@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(list(products.values()))

@app.route('/products', methods=['POST'])
def create_product():
    global product_counter
    data = request.json
    product_counter += 1
    product = {
        'id': product_counter,
        'name': data.get('name'),
        'price': data.get('price'),
        'stock': data.get('stock', 0),
        'description': data.get('description', ''),
        'created_at': datetime.now().isoformat()
    }
    products[product_counter] = product
    return jsonify(product), 201

@app.route('/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    product = products.get(product_id)
    if product:
        return jsonify(product)
    return jsonify({'error': 'Product not found'}), 404

@app.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    if product_id not in products:
        return jsonify({'error': 'Product not found'}), 404
    
    data = request.json
    products[product_id].update({
        'name': data.get('name', products[product_id]['name']),
        'price': data.get('price', products[product_id]['price']),
        'stock': data.get('stock', products[product_id]['stock']),
        'description': data.get('description', products[product_id]['description']),
        'updated_at': datetime.now().isoformat()
    })
    return jsonify(products[product_id])

@app.route('/products/<int:product_id>/stock', methods=['PATCH'])
def update_stock(product_id):
    if product_id not in products:
        return jsonify({'error': 'Product not found'}), 404
    
    data = request.json
    quantity = data.get('quantity', 0)
    products[product_id]['stock'] += quantity
    return jsonify({'id': product_id, 'stock': products[product_id]['stock']})

@app.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    if product_id not in products:
        return jsonify({'error': 'Product not found'}), 404
    del products[product_id]
    return '', 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)