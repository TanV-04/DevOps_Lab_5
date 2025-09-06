# Kubernetes Autoscaling Demo

This project demonstrates Kubernetes autoscaling capabilities including Horizontal Pod Autoscaler (HPA) and Cluster Autoscaler.

## Features

1. **Horizontal Pod Autoscaler (HPA)**: Automatically scales pods based on CPU and memory utilization
2. **Cluster Autoscaler**: Automatically scales cluster nodes when pods can't be scheduled
3. **Load Testing**: Generate traffic to trigger autoscaling

## Prerequisites

- Kubernetes cluster (EKS, GKE, AKS, or local cluster)
- kubectl configured
- Metrics Server installed in the cluster

## Quick Start

### 1. Install Metrics Server (if not already installed)
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### 2. Deploy the Application
```bash
kubectl apply -f deployment.yaml
```

### 3. Configure Horizontal Pod Autoscaler
```bash
kubectl apply -f hpa.yaml
```

### 4. Configure Cluster Autoscaler (AWS EKS example)
```bash
# Update cluster-autoscaler.yaml with your cluster name
kubectl apply -f cluster-autoscaler.yaml
```

### 5. Generate Load to Test Autoscaling
```bash
kubectl apply -f load-test.yaml
```

## Monitoring Autoscaling

### Check HPA Status
```bash
kubectl get hpa webapp-hpa -w
```

### Check Pod Scaling
```bash
kubectl get pods -l app=webapp -w
```

### Check Cluster Autoscaler Logs
```bash
kubectl logs -f deployment/cluster-autoscaler -n kube-system
```

## Configuration Details

### HPA Configuration
- **Min Replicas**: 2
- **Max Replicas**: 10
- **CPU Target**: 70% utilization
- **Memory Target**: 80% utilization
- **Scale Down Stabilization**: 5 minutes
- **Scale Up Policies**: Aggressive scaling (up to 100% increase every 15 seconds)

### Resource Requests and Limits
- **CPU Request**: 100m (0.1 CPU)
- **CPU Limit**: 500m (0.5 CPU)
- **Memory Request**: 128Mi
- **Memory Limit**: 512Mi

### Cluster Autoscaler
- **Cloud Provider**: AWS (configurable)
- **Expander**: least-waste
- **Auto-discovery**: Based on ASG tags
- **Balance Similar Node Groups**: Enabled

## Testing Scenarios

### 1. CPU-based Scaling
The load test generates HTTP requests that will increase CPU utilization, triggering HPA to scale up pods.

### 2. Node Scaling
When HPA scales beyond available node capacity, Cluster Autoscaler will provision new nodes.

### 3. Scale Down
When load decreases, HPA will scale down pods after the stabilization window, and Cluster Autoscaler will remove underutilized nodes.

## Cleanup
```bash
kubectl delete -f load-test.yaml
kubectl delete -f hpa.yaml
kubectl delete -f deployment.yaml
kubectl delete -f cluster-autoscaler.yaml
```

## Notes

- Adjust resource requests/limits based on your application requirements
- Update cluster-autoscaler.yaml with your specific cloud provider and cluster configuration
- Monitor costs when using cluster autoscaling in cloud environments
- Consider using Vertical Pod Autoscaler (VPA) for optimizing resource requests