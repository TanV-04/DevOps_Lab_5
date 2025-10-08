from flask import Flask, jsonify
import os

app = Flask(__name__)

SERVICE_NAME = os.environ.get('SERVICE_NAME', 'service-b')
DB_HOST = os.environ.get('DB_HOST', 'localhost')
API_KEY = os.environ.get('API_KEY', 'default')

products = [{"id": 1, "name": "Laptop", "price": 1000}, {"id": 2, "name": "Phone", "price": 500}]

@app.route('/health')
def health():
    return jsonify({"service": SERVICE_NAME, "status": "healthy"})

@app.route('/products')
def get_products():
    return jsonify({"service": SERVICE_NAME, "data": products, "db_host": DB_HOST})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
