# Assignment 6: Kubernetes Cluster with Autoscaling

This assignment demonstrates creating a Kubernetes cluster with Horizontal Pod Autoscaling (HPA) feature.

## Files:
- `deployment.yaml`: Nginx deployment with resource limits
- `service.yaml`: LoadBalancer service to expose nginx
- `hpa.yaml`: Horizontal Pod Autoscaler configuration

## Steps to Deploy:

1. Create a Kubernetes cluster (e.g., using Minikube, EKS, GKE, etc.)
   ```bash
   minikube start
   ```

2. Apply the manifests:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f hpa.yaml
   ```

3. Check the HPA:
   ```bash
   kubectl get hpa
   kubectl describe hpa nginx-hpa
   ```

4. Test autoscaling by generating load:
   ```bash
   kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://nginx-service; done"
   ```

5. Monitor scaling:
   ```bash
   kubectl get pods -w
   kubectl get hpa -w
   ```

The HPA will scale the nginx pods based on CPU (50%) and memory (70%) utilization.
