# Assignment9: Apache2 Server on Kubernetes

## Description
Create an Apache2 server deployment and access it from the host machine using Kubernetes commands. Uses official Apache HTTP Server image with a custom index.html.

## Setup
1. Install minikube and start: `minikube start`
2. Apply YAMLs: `kubectl apply -f .`
3. Access the server:
   - Using minikube: `minikube service apache-svc`
   - Or port-forward: `kubectl port-forward svc/apache-svc 8080:80`
4. Visit http://localhost:8080 (or minikube IP) to see "Hello from Apache2 on Kubernetes!"

## Files
- apache-deployment.yaml
- apache-service.yaml
- index.html (custom content mounted as volume)
