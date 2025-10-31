## Project Overview
This project deploys MongoDB database and Mongo Express web interface on Kubernetes with:
- Secret for credentials
- ConfigMap for database configuration
- PersistentVolumeClaim for data persistence
- Deployments for both applications
- Services for networking

## Prerequisites
- Kubernetes cluster running (Minikube, Kind, or any K8s cluster)
- kubectl installed and configured

## Step-by-Step Deployment Instructions

### Step 1: Verify Kubernetes Cluster
```bash
kubectl cluster-info
kubectl get nodes
```

### Step 2: Create Secret (credentials)
```bash
kubectl apply -f 00-secret.yml
kubectl get secrets
```

### Step 3: Create ConfigMap (database config)
```bash
kubectl apply -f 01-configmap.yml
kubectl get configmaps
```

### Step 4: Create PersistentVolumeClaim (storage)
```bash
kubectl apply -f 02-pvc.yml
kubectl get pvc
```

### Step 5: Deploy MongoDB
```bash
kubectl apply -f 03-mongo-deployment.yml
kubectl get deployments
kubectl get pods
```

### Step 6: Create MongoDB Service
```bash
kubectl apply -f 04-mongo-service.yml
kubectl get services
```

### Step 7: Deploy Mongo Express
```bash
kubectl apply -f 05-mongo-express-deployment.yml
kubectl get deployments
```

### Step 8: Create Mongo Express Service
```bash
kubectl apply -f 06-mongo-express-service.yml
kubectl get services

###Step 9: Open browser
http://localhost:30000
and put username and password