# Assignment 9: Apache2 Server Deployment

This assignment demonstrates creating an Apache2 server within a Kubernetes deployment and accessing it using commands from the host machine.

## Files:
- `apache-deployment.yaml`: Deployment for Apache2 server with configmap volume
- `apache-service.yaml`: NodePort service to expose Apache on host-accessible port
- `apache-configmap.yaml`: ConfigMap containing custom HTML content

## Prerequisites:
- Kubernetes cluster running
- kubectl configured

## Steps to Deploy:

1. Apply the configmap:
   ```bash
   kubectl apply -f apache-configmap.yaml
   ```

2. Deploy the Apache server:
   ```bash
   kubectl apply -f apache-deployment.yaml
   kubectl apply -f apache-service.yaml
   ```

3. Check deployment status:
   ```bash
   kubectl get deployments
   kubectl get services
   kubectl get pods
   ```

4. Access from host machine:
   - Get the NodePort:
     ```bash
     kubectl get service apache-service
     ```
     Note the PORT(S) column, e.g., 80:31234/TCP means NodePort is 31234

   - Get node IP (if using minikube):
     ```bash
     minikube ip
     ```

   - Access via browser or curl:
     ```bash
     curl http://<node-ip>:<node-port>
     ```
     Or open in browser: http://<node-ip>:<node-port>

## Learning Kubernetes Commands:
- `kubectl get nodes`: List cluster nodes
- `kubectl describe pod <pod-name>`: Get detailed pod information
- `kubectl logs <pod-name>`: View pod logs
- `kubectl exec -it <pod-name> -- /bin/bash`: Access pod shell
- `kubectl port-forward service/apache-service 8080:80`: Port forward to localhost

## Cleanup:
```bash
kubectl delete -f apache-service.yaml
kubectl delete -f apache-deployment.yaml
kubectl delete -f apache-configmap.yaml
