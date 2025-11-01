# 🚀 Project 9: Apache2 Server on Kubernetes

## 📋 Overview

Deploy Apache2 web server in Kubernetes and access it from your host machine using various Kubernetes commands.

---

## 🎯 What This Project Includes

### **Components:**
- **Apache2 Server** (httpd:2.4) - Industry-standard web server
- **3 Replicas** - High availability and load balancing
- **Custom ConfigMap** - Custom HTML page and Apache configuration
- **NodePort Service** - External access on port 30090
- **Health Checks** - Automatic monitoring and recovery

### **Files:**
- `00-namespace.yml` - Namespace for isolation
- `01-configmap.yml` - Custom configuration and HTML
- `02-deployment.yml` - Apache2 deployment
- `03-service.yml` - NodePort service
- `deploy.sh` - Automated deployment script
- `DEPLOYMENT-GUIDE.md` - Detailed instructions
- `QUICK-REFERENCE.md` - Quick commands

---

## 🚀 Quick Start

### **Step 1: Deploy**
```bash
chmod +x deploy.sh
./deploy.sh
```

### **Step 2: Access**
Open browser: **http://localhost:30090**

Or use command line:
```bash
curl http://localhost:30090
```

That's it! ✨

---

## 📊 Architecture

```
Host Machine (Browser/curl)
         ↓
    localhost:30090
         ↓
  NodePort Service
         ↓
    Load Balancer
         ↓
  ┌──────┼──────┐
  ↓      ↓      ↓
Pod 1  Pod 2  Pod 3
(Apache) (Apache) (Apache)
```

---

## 🎓 Learning Objectives

This project teaches you:

### **Kubernetes Concepts:**
✅ **Deployments** - Managing replicated applications  
✅ **Services** - Exposing applications (NodePort type)  
✅ **ConfigMaps** - Separating configuration from code  
✅ **Namespaces** - Organizing resources  
✅ **Labels & Selectors** - Identifying resources  
✅ **Health Probes** - Monitoring application health  
✅ **Resource Management** - CPU and memory limits  

### **Commands You'll Use:**
- `kubectl apply` - Deploy resources
- `kubectl get` - List resources
- `kubectl describe` - Detailed information
- `kubectl logs` - View application logs
- `kubectl exec` - Run commands in containers
- `kubectl scale` - Change replica count
- `kubectl delete` - Remove resources

---

## 📝 What Makes This Different

### **Previous Projects vs This One:**

| Project 7 | Project 8 | Project 9 |
|-----------|-----------|-----------|
| 2 services | 4 microservices | 1 web server |
| MongoDB + UI | Full e-commerce | Apache2 |
| Complex setup | Multiple services | Simple & focused |
| Port 30000 | Port 30080 | Port 30090 |

**Project 9 Focus:** Master Kubernetes commands and concepts with a simple, clear example.

---

## 🧪 Testing & Commands

### **Basic Access:**
```bash
# Browser
http://localhost:30090

# Command line
curl http://localhost:30090
```

### **View Resources:**
```bash
# Everything
kubectl get all -n apache-server

# Just pods
kubectl get pods -n apache-server

# Services
kubectl get svc -n apache-server
```

### **View Logs:**
```bash
# All apache pods
kubectl logs -l app=apache2 -n apache-server

# Specific pod
kubectl logs <pod-name> -n apache-server

# Follow logs
kubectl logs -f -l app=apache2 -n apache-server
```

### **Scale Replicas:**
```bash
# Scale to 5
kubectl scale deployment apache2-deployment -n apache-server --replicas=5

# Check
kubectl get pods -n apache-server
```

### **Access Pod:**
```bash
# Shell access
kubectl exec -it <pod-name> -n apache-server -- /bin/bash

# Run command
kubectl exec <pod-name> -n apache-server -- ls /usr/local/apache2/htdocs
```

---

## 📸 Lab Report

### **Screenshots Needed:**

1. **Deployment Output:**
```bash
kubectl get all -n apache-server
```

2. **Pods Running:**
```bash
kubectl get pods -n apache-server -o wide
```

3. **Service Details:**
```bash
kubectl describe service apache2-service -n apache-server
```

4. **Browser Access:**
- Screenshot of http://localhost:30090

5. **Command Line Access:**
```bash
curl http://localhost:30090
```

6. **Logs:**
```bash
kubectl logs -l app=apache2 -n apache-server --tail=20
```

---

## 🔍 Verification

### **Check if Working:**

✅ **Pods Running:**
```bash
kubectl get pods -n apache-server
# Should show 3 pods in Running state
```

✅ **Service Exposed:**
```bash
kubectl get svc -n apache-server
# Should show NodePort 30090
```

✅ **Website Accessible:**
```bash
curl http://localhost:30090
# Should return HTML
```

✅ **Health Checks Passing:**
```bash
kubectl describe pod <pod-name> -n apache-server
# Liveness: Successful
# Readiness: Successful
```

---

## 🗑️ Cleanup

```bash
kubectl delete namespace apache-server
```

This removes everything cleanly!

---

## 💡 Tips

1. **Port in use?** Change nodePort in `03-service.yml`
2. **Pods not starting?** Check logs: `kubectl logs <pod-name> -n apache-server`
3. **Can't access?** Verify service: `kubectl get svc -n apache-server`
4. **Want more replicas?** Scale it: `kubectl scale deployment apache2-deployment -n apache-server --replicas=10`



**Access your Apache2 server at: http://localhost:30090** 🚀


