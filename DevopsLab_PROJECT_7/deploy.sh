#!/bin/bash

# MongoDB and Mongo Express Deployment Script
# This script deploys all components in the correct order

echo "=========================================="
echo "MongoDB & Mongo Express Deployment"
echo "=========================================="
echo ""

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Check cluster connectivity
echo "🔍 Checking Kubernetes cluster..."
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your cluster."
    exit 1
fi
echo "✅ Cluster is accessible"
echo ""

# Deploy Secret
echo "📝 Step 1/6: Creating Secret..."
kubectl apply -f 00-secret.yml
if [ $? -eq 0 ]; then
    echo "✅ Secret created"
else
    echo "❌ Failed to create Secret"
    exit 1
fi
echo ""

# Deploy ConfigMap
echo "📝 Step 2/6: Creating ConfigMap..."
kubectl apply -f 01-configmap.yml
if [ $? -eq 0 ]; then
    echo "✅ ConfigMap created"
else
    echo "❌ Failed to create ConfigMap"
    exit 1
fi
echo ""

# Deploy PVC
echo "📝 Step 3/6: Creating PersistentVolumeClaim..."
kubectl apply -f 02-pvc.yml
if [ $? -eq 0 ]; then
    echo "✅ PVC created"
else
    echo "❌ Failed to create PVC"
    exit 1
fi
echo ""

# Deploy MongoDB
echo "📝 Step 4/6: Deploying MongoDB..."
kubectl apply -f 03-mongo-deployment.yml
kubectl apply -f 04-mongo-service.yml
if [ $? -eq 0 ]; then
    echo "✅ MongoDB deployed"
else
    echo "❌ Failed to deploy MongoDB"
    exit 1
fi
echo ""

# Wait for MongoDB to be ready
echo "⏳ Waiting for MongoDB pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mongo --timeout=120s
if [ $? -eq 0 ]; then
    echo "✅ MongoDB is ready"
else
    echo "⚠️  MongoDB pod is taking longer than expected"
fi
echo ""

# Deploy Mongo Express
echo "📝 Step 5/6: Deploying Mongo Express..."
kubectl apply -f 05-mongo-express-deployment.yml
kubectl apply -f 06-mongo-express-service.yml
if [ $? -eq 0 ]; then
    echo "✅ Mongo Express deployed"
else
    echo "❌ Failed to deploy Mongo Express"
    exit 1
fi
echo ""

# Wait for Mongo Express to be ready
echo "⏳ Waiting for Mongo Express pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mongo-express --timeout=120s
if [ $? -eq 0 ]; then
    echo "✅ Mongo Express is ready"
else
    echo "⚠️  Mongo Express pod is taking longer than expected"
fi
echo ""

# Display status
echo "📊 Step 6/6: Deployment Status"
echo "=========================================="
echo ""
echo "Pods:"
kubectl get pods
echo ""
echo "Services:"
kubectl get services
echo ""
echo "PVC:"
kubectl get pvc
echo ""

# Access instructions
echo "=========================================="
echo "🎉 Deployment Complete!"
echo "=========================================="
echo ""
echo "To access Mongo Express:"
echo ""

# Check if running on Minikube
if kubectl config current-context | grep -q "minikube"; then
    echo "Run this command:"
    echo "  minikube service mongo-express-service"
else
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
    echo "Open in browser:"
    echo "  http://${NODE_IP}:30000"
    echo ""
    echo "Or get node IP manually:"
    echo "  kubectl get nodes -o wide"
fi

echo ""
echo "To check logs:"
echo "  kubectl logs -l app=mongo"
echo "  kubectl logs -l app=mongo-express"
echo ""
echo "To delete all resources:"
echo "  kubectl delete -f ."
echo ""
