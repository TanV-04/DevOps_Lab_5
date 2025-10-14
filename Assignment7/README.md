# Assignment7: MongoDB and MongoExpress on Kubernetes

## Description
Create MongoDB and MongoExpress deployments, services, configmaps, and secrets. MongoExpress is a web UI for MongoDB.

## Setup
1. Install minikube and start: `minikube start`
2. Apply YAMLs: `kubectl apply -f .`
3. Access MongoExpress: `minikube service mongo-express-svc` or `kubectl port-forward svc/mongo-express-svc 8081:8081`
4. MongoDB root password in secret 'mongo-secret'.

## Files
- mongo-deployment.yaml
- mongo-service.yaml
- mongo-configmap.yaml
- mongo-secret.yaml
- mongo-express-deployment.yaml
- mongo-express-service.yaml
