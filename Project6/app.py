from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to Social Media App!",
        "server": os.environ.get('HOSTNAME', 'unknown'),
        "status": "running"
    })

@app.route('/posts')
def posts():
    return jsonify({
        "posts": [
            {"id": 1, "content": "Hello World!"},
            {"id": 2, "content": "Kubernetes is cool!"}
        ]
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)  # Changed from 5000 to 8081