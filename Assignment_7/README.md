# Assignment 7: MongoDB and Mongo Express Deployments

This assignment demonstrates deploying MongoDB and Mongo Express with Kubernetes using deployments, services, configmaps, and secrets.

## Files:
- `mongo-deployment.yaml`: MongoDB deployment with persistent volume
- `mongo-service.yaml`: ClusterIP service for MongoDB
- `mongo-configmap.yaml`: ConfigMap for MongoDB URL
- `mongo-secret.yaml`: Secret for MongoDB credentials
- `mongo-express-deployment.yaml`: Mongo Express deployment
- `mongo-express-service.yaml`: LoadBalancer service for Mongo Express
- `mongo-express-configmap.yaml`: ConfigMap for Mongo Express settings
- `mongo-express-secret.yaml`: Secret for Mongo Express basic auth

## Steps to Deploy:

1. Create a PersistentVolumeClaim for MongoDB storage (if not using dynamic provisioning):
   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: mongo-pvc
   spec:
     accessModes:
       - ReadWriteOnce
     resources:
       requests:
         storage: 1Gi
   ```

2. Apply all manifests:
   ```bash
   kubectl apply -f mongo-configmap.yaml
   kubectl apply -f mongo-secret.yaml
   kubectl apply -f mongo-deployment.yaml
   kubectl apply -f mongo-service.yaml
   kubectl apply -f mongo-express-configmap.yaml
   kubectl apply -f mongo-express-secret.yaml
   kubectl apply -f mongo-express-deployment.yaml
   kubectl apply -f mongo-express-service.yaml
   ```

3. Check deployments:
   ```bash
   kubectl get deployments
   kubectl get services
   kubectl get pods
   ```

4. Access Mongo Express:
   - Get the external IP: `kubectl get svc mongo-express-service`
   - Open in browser: `http://<external-ip>:8081`
   - Login with admin/password

MongoDB is accessible internally at `mongo-service:27017`.
