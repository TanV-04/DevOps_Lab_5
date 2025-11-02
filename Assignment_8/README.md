# Assignment 8: Complete Application with 4 Microservices

This assignment demonstrates containerizing a complete application with 4 microservices (user, product, order, payment) plus a frontend, using Kubernetes deployments, services, configmaps, and secrets.

## Architecture:
- **User Service**: Manages user data
- **Product Service**: Manages product catalog
- **Order Service**: Handles order processing
- **Payment Service**: Processes payments
- **Frontend**: Angular web application
- **MongoDB**: Shared database (from Assignment 7)

## Files:
- `user-service-*`: Deployment, service, configmap, secret for user service
- `product-service-*`: Deployment, service, configmap, secret for product service
- `order-service-*`: Deployment, service, configmap, secret for order service
- `payment-service-*`: Deployment, service, configmap, secret for payment service
- `frontend-*`: Deployment, service, configmap, secret for frontend

## Prerequisites:
- MongoDB from Assignment 7 must be deployed first
- Docker images for Spring Boot services (spring-boot-demo:latest) and Angular frontend (angular-app:latest) must be built

## Steps to Deploy:

1. Deploy MongoDB first (from Assignment 7)

2. Apply all configmaps and secrets:
   ```bash
   kubectl apply -f *-configmap.yaml
   kubectl apply -f *-secret.yaml
   ```

3. Deploy services:
   ```bash
   kubectl apply -f user-service-deployment.yaml
   kubectl apply -f user-service-service.yaml
   kubectl apply -f product-service-deployment.yaml
   kubectl apply -f product-service-service.yaml
   kubectl apply -f order-service-deployment.yaml
   kubectl apply -f order-service-service.yaml
   kubectl apply -f payment-service-deployment.yaml
   kubectl apply -f payment-service-service.yaml
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml
   ```

4. Check deployments:
   ```bash
   kubectl get deployments
   kubectl get services
   kubectl get pods
   ```

5. Access the application:
   - Frontend: Get external IP of frontend service
   - Services communicate internally via ClusterIP services

## Scaling:
Each microservice has 2 replicas. You can scale using:
```bash
kubectl scale deployment user-service --replicas=3
