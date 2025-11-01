from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>Frontend Service</h2><p>Welcome to the main UI</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
