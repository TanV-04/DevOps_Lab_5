from flask import Flask, jsonify
import os

app = Flask(__name__)

SERVICE_NAME = os.environ.get('SERVICE_NAME', 'service-c')
DB_HOST = os.environ.get('DB_HOST', 'localhost')
API_KEY = os.environ.get('API_KEY', 'default')

orders = [{"id": 1, "user_id": 1, "product_id": 1, "status": "pending"}]

@app.route('/health')
def health():
    return jsonify({"service": SERVICE_NAME, "status": "healthy"})

@app.route('/orders')
def get_orders():
    return jsonify({"service": SERVICE_NAME, "data": orders, "db_host": DB_HOST})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
