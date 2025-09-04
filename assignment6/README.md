# Kubernetes Autoscaling Demonstration

This project demonstrates how to create a Kubernetes cluster with autoscaling features for application scalability using a basic social media application.

## Application Overview

The social media application is a simple Node.js Express API with the following features:
- GET / : Welcome message
- GET /posts : Retrieve all posts (includes CPU-intensive operation for autoscaling demo)
- POST /posts : Create a new post

## Prerequisites

- Docker installed
- Kubernetes cluster (e.g., minikube, kind, or cloud provider)
- kubectl installed and configured

## Setup Instructions

1. Build the Docker image:
   ```bash
   cd assignment6
   docker build -f DockerFile -t social-media-app:latest .
   ```

2. Start a local Kubernetes cluster (using minikube as example):
   ```bash
   minikube start
   ```

3. Load the Docker image into minikube (if using minikube):
   ```bash
   minikube image load social-media-app:latest
   ```

4. Apply the Kubernetes manifests:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f hpa.yaml
   ```

5. Verify the deployment:
   ```bash
   kubectl get deployments
   kubectl get pods
   kubectl get hpa
   kubectl get services
   ```

## Testing Autoscaling

1. Expose the service to access the application:
   ```bash
   kubectl port-forward svc/social-media-service 8080:80
   ```

2. Test the application:
   ```bash
   curl http://localhost:8080/
   curl http://localhost:8080/posts
   curl -X POST -H "Content-Type: application/json" -d '{"user":"testuser","content":"Hello World!"}' http://localhost:8080/posts
   ```

3. Generate load to trigger autoscaling:
   ```bash
   kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://social-media-service; done"
   ```

4. Monitor the autoscaling:
   ```bash
   kubectl get hpa -w
   kubectl get pods -w
   ```

5. Stop the load generator and observe scale-down:
   - The HPA should automatically scale down the pods when CPU usage drops below 50%.

## Cleanup

```bash
kubectl delete -f hpa.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
minikube stop
