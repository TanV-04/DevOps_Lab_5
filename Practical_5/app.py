from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask + Kubernetes + Minikube 🚀"

if __name__ == "__main__":
    # Listen on 0.0.0.0 so Kubernetes can access it
    app.run(host="0.0.0.0", port=5000)
