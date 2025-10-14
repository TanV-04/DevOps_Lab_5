# Assignment8: Multi-Microservice Application on Kubernetes

## Description
Containerize a complete application with at least 4 microservices: User Service, Product Service, Order Service, and API Gateway. Each service uses a simple Nginx container for demo purposes, with ConfigMaps for configuration and Secrets for sensitive data (e.g., API keys).

## Setup
1. Install minikube and start: `minikube start`
2. Apply YAMLs: `kubectl apply -f .`
3. Access services: Use `kubectl port-forward` or NodePort.
   - User Service: port 3001
   - Product Service: port 3002
   - Order Service: port 3003
   - API Gateway: port 3000 (proxies to others)

## Files
- configmap.yaml
- secret.yaml
- user-deployment.yaml, user-service.yaml
- product-deployment.yaml, product-service.yaml
- order-deployment.yaml, order-service.yaml
- gateway-deployment.yaml, gateway-service.yaml
