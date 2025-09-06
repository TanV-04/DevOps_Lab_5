#!/bin/bash

# Jenkins Deployment Script for Kubernetes Autoscaling Demo
# Usage: ./jenkins-deploy.sh [environment] [options]

set -e

# Default values
ENVIRONMENT=${1:-dev}
NAMESPACE=${ENVIRONMENT}
DEPLOY_CLUSTER_AUTOSCALER=${2:-false}
RUN_LOAD_TEST=${3:-false}

echo "=== Kubernetes Autoscaling Deployment ==="
echo "Environment: $ENVIRONMENT"
echo "Namespace: $NAMESPACE"
echo "Deploy Cluster Autoscaler: $DEPLOY_CLUSTER_AUTOSCALER"
echo "Run Load Test: $RUN_LOAD_TEST"
echo "========================================"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install kubectl if not present
if ! command_exists kubectl; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/v1.31.4/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Create namespace if not default
if [ "$NAMESPACE" != "default" ]; then
    echo "Creating namespace: $NAMESPACE"
    kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
fi

# Deploy application
echo "Deploying application to namespace: $NAMESPACE"
kubectl apply -f deployment.yaml -n $NAMESPACE

# Wait for deployment
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/webapp-deployment -n $NAMESPACE --timeout=300s

# Deploy HPA
echo "Deploying Horizontal Pod Autoscaler..."
kubectl apply -f hpa.yaml -n $NAMESPACE

# Deploy Cluster Autoscaler if requested
if [ "$DEPLOY_CLUSTER_AUTOSCALER" == "true" ]; then
    echo "Deploying Cluster Autoscaler..."
    kubectl apply -f cluster-autoscaler.yaml
fi

# Verify deployment
echo "Verifying deployment..."
kubectl get pods -l app=webapp -n $NAMESPACE
kubectl get hpa webapp-hpa -n $NAMESPACE
kubectl get service webapp-service -n $NAMESPACE

# Wait for HPA metrics
echo "Waiting for HPA metrics..."
for i in {1..12}; do
    if kubectl get hpa webapp-hpa -n $NAMESPACE -o jsonpath='{.status.currentMetrics}' | grep -q "value"; then
        echo "HPA metrics available"
        break
    fi
    echo "Waiting for metrics... ($i/12)"
    sleep 10
done

# Run load test if requested
if [ "$RUN_LOAD_TEST" == "true" ]; then
    echo "Starting load test..."
    kubectl apply -f intensive-load.yaml -n $NAMESPACE
    
    echo "Monitoring scaling for 5 minutes..."
    timeout 300s kubectl get hpa webapp-hpa -n $NAMESPACE -w &
    HPA_PID=$!
    
    sleep 300
    
    # Stop monitoring
    kill $HPA_PID 2>/dev/null || true
    
    echo "Final scaling status:"
    kubectl get hpa webapp-hpa -n $NAMESPACE
    kubectl get pods -l app=webapp -n $NAMESPACE
    
    # Cleanup load test
    echo "Cleaning up load test..."
    kubectl delete -f intensive-load.yaml -n $NAMESPACE || true
fi

# Health check
echo "Performing health check..."
SERVICE_IP=$(kubectl get service webapp-service -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")

if [ -z "$SERVICE_IP" ]; then
    # For minikube or local clusters
    kubectl port-forward service/webapp-service 8080:80 -n $NAMESPACE &
    PORT_FORWARD_PID=$!
    sleep 5
    
    if curl -f http://localhost:8080 > /dev/null 2>&1; then
        echo "✅ Health check passed!"
    else
        echo "❌ Health check failed!"
        exit 1
    fi
    
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    if curl -f http://$SERVICE_IP > /dev/null 2>&1; then
        echo "✅ Health check passed!"
    else
        echo "❌ Health check failed!"
        exit 1
    fi
fi

echo "🎉 Deployment completed successfully!"
echo "=== Final Status ==="
kubectl get all -l app=webapp -n $NAMESPACE
kubectl get hpa -n $NAMESPACE