# Quick Reference - Project 9: Apache2 Server

## 🚀 Deploy in One Command
```bash
./deploy.sh
```

## 🌐 Access Server
```
http://localhost:30090
```

## 📋 Manual Deploy
```bash
kubectl apply -f 00-namespace.yml
kubectl apply -f 01-configmap.yml
kubectl apply -f 02-deployment.yml
kubectl apply -f 03-service.yml
```

## 📊 Essential Commands

### Check Status
```bash
kubectl get all -n apache-server
kubectl get pods -n apache-server
```

### View Logs
```bash
kubectl logs -l app=apache2 -n apache-server
```

### Test Access
```bash
curl http://localhost:30090
```

### Scale Replicas
```bash
kubectl scale deployment apache2-deployment -n apache-server --replicas=5
```

### Describe Resources
```bash
kubectl describe deployment apache2-deployment -n apache-server
kubectl describe service apache2-service -n apache-server
```

### Execute in Pod
```bash
kubectl exec -it <pod-name> -n apache-server -- /bin/bash
```

### Port Forward
```bash
kubectl port-forward -n apache-server deployment/apache2-deployment 8080:80
# Access at: http://localhost:8080
```

## 🗑️ Delete
```bash
kubectl delete namespace apache-server
```

## 📸 For Lab Report

**Run these commands:**
```bash
kubectl get all -n apache-server
kubectl get pods -n apache-server -o wide
kubectl describe deployment apache2-deployment -n apache-server
kubectl logs -l app=apache2 -n apache-server --tail=20
curl http://localhost:30090
```

**Screenshot:**
- Terminal output
- Browser at http://localhost:30090

## ✅ Success Checklist
- [ ] 3 pods running
- [ ] Service created (NodePort 30090)
- [ ] ConfigMap applied
- [ ] Accessible at localhost:30090
- [ ] All health checks passing

---

**Access:** http://localhost:30090 🚀
