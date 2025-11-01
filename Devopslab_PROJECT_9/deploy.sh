#!/bin/bash

echo "=========================================="
echo "Apache2 Server Deployment - Project 9"
echo "=========================================="
echo ""

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found"
    exit 1
fi

echo "🔍 Checking Kubernetes cluster..."
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to cluster"
    exit 1
fi
echo "✅ Cluster is accessible"
echo ""

# Step 1: Create Namespace
echo "📝 Step 1/3: Creating Namespace..."
kubectl apply -f 00-namespace.yml
echo "✅ Namespace created"
echo ""
sleep 2

# Step 2: Create ConfigMap
echo "📝 Step 2/3: Creating ConfigMap..."
kubectl apply -f 01-configmap.yml
echo "✅ ConfigMap created"
echo ""
sleep 2

# Step 3: Deploy Apache2
echo "📝 Step 3/3: Deploying Apache2 Server..."
kubectl apply -f 02-deployment.yml
kubectl apply -f 03-service.yml
echo "✅ Apache2 deployed"
echo ""

# Wait for pods
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=apache2 -n apache-server --timeout=60s
echo ""

# Display status
echo "=========================================="
echo "📊 Deployment Status"
echo "=========================================="
echo ""
echo "Pods:"
kubectl get pods -n apache-server
echo ""
echo "Services:"
kubectl get services -n apache-server
echo ""
echo "ConfigMaps:"
kubectl get configmaps -n apache-server
echo ""

# Access instructions
echo "=========================================="
echo "🎉 Deployment Complete!"
echo "=========================================="
echo ""
echo "🌐 Access Apache2 Server:"
echo ""
echo "  URL: http://localhost:30090"
echo ""
echo "📊 Check Status:"
echo "  kubectl get all -n apache-server"
echo ""
echo "📝 View Logs:"
echo "  kubectl logs -l app=apache2 -n apache-server"
echo ""
echo "🔍 Describe Deployment:"
echo "  kubectl describe deployment apache2-deployment -n apache-server"
echo ""
echo "🗑️  Delete All:"
echo "  kubectl delete namespace apache-server"
echo ""
echo "✨ Your Apache2 server is ready!"
echo ""
