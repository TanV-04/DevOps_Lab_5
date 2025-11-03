from flask import Flask, jsonify
import os

app = Flask(__name__)

SERVICE_NAME = os.environ.get('SERVICE_NAME', 'service-d')
DB_HOST = os.environ.get('DB_HOST', 'localhost')
API_KEY = os.environ.get('API_KEY', 'default')

payments = [{"id": 1, "order_id": 1, "amount": 1000, "status": "completed"}]

@app.route('/health')
def health():
    return jsonify({"service": SERVICE_NAME, "status": "healthy"})

@app.route('/payments')
def get_payments():
    return jsonify({"service": SERVICE_NAME, "data": payments, "db_host": DB_HOST})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
