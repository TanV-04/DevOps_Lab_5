from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/data')
def data():
    return jsonify({"data": ["apple", "banana", "mango"]})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7000)
