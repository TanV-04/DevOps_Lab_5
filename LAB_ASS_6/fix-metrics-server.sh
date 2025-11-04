#!/bin/bash

# Fix metrics server issues in kind cluster

set -e

echo "🔍 Checking metrics server status..."

# Check if metrics server exists
if ! kubectl get deployment metrics-server -n kube-system &>/dev/null; then
    echo "❌ Metrics server not found. Installing..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    sleep 5
fi

echo "📊 Current metrics server status:"
kubectl get pods -n kube-system -l k8s-app=metrics-server

echo ""
echo "🔧 Applying kind-specific patches..."

# Delete existing pods to force restart with new config
kubectl delete pods -n kube-system -l k8s-app=metrics-server --ignore-not-found=true

# Patch with all necessary flags for kind
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[
  {
    "op": "replace",
    "path": "/spec/template/spec/containers/0/args",
    "value": [
      "--cert-dir=/tmp",
      "--secure-port=4443",
      "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
      "--kubelet-use-node-status-port",
      "--metric-resolution=15s",
      "--kubelet-insecure-tls"
    ]
  }
]'

echo "⏳ Waiting for metrics server to restart..."
sleep 10

echo "📈 Checking if metrics server is working..."
for i in {1..12}; do
    echo "Attempt $i/12..."
    if kubectl get pods -n kube-system -l k8s-app=metrics-server | grep -q "Running"; then
        echo "✅ Metrics server pod is running"
        break
    fi
    sleep 10
done

echo ""
echo "🧪 Testing metrics API..."
sleep 30  # Give metrics server time to collect data

if kubectl top nodes &>/dev/null; then
    echo "✅ Metrics server is working correctly!"
    kubectl top nodes
else
    echo "⚠️  Metrics server may still be starting up"
    echo "💡 Try running this script again in a few minutes"
    echo "💡 Or check logs: kubectl logs -n kube-system -l k8s-app=metrics-server"
fi

echo ""
echo "📊 Final status:"
kubectl get pods -n kube-system -l k8s-app=metrics-server
echo ""
echo "🎯 To test HPA after metrics server is ready:"
echo "   kubectl get hpa ping-server-hpa"
echo "   ./test-autoscaling.sh"
