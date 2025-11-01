# Project 9: Apache2 Server on Kubernetes

### **Overview:**
Deploy Apache2 web server in Kubernetes and access it from your host machine using commands.

---

## What I have Deployed

- **Apache2 Server** (httpd:2.4)
- **3 Replicas** for high availability
- **ConfigMap** with custom HTML and Apache config
- **NodePort Service** for external access on port 30090
- **Health Checks** (liveness and readiness probes)

---

## 📁 Files Included

```
00-namespace.yml     - Creates 'apache-server' namespace
01-configmap.yml     - Custom HTML and Apache configuration
02-deployment.yml    - Apache2 deployment (3 replicas)
03-service.yml       - NodePort service (port 30090)
deploy.sh            - Automated deployment script
```

---

## 🚀 Deployment

### **Deploy All at Once**
```bash
kubectl apply -f .
```

---

## 🌐 Accessing Apache2 Server

### **From Your Host Machine:**

#### **Option 1: Browser (Easiest)**
```
http://localhost:30090
```

#### **Option 2: curl Command**
```bash
curl http://localhost:30090
```

---

## 📊 Kubernetes Commands to Learn

### **View All Resources:**
```bash
kubectl get all -n apache-server
```

### **View Pods:**
```bash
# List all pods
kubectl get pods -n apache-server

# Watch pods in real-time
kubectl get pods -n apache-server -w

# Get pod details
kubectl get pods -n apache-server -o wide
```

### **View Services:**
```bash
# List services
kubectl get services -n apache-server

# Describe service
kubectl describe service apache2-service -n apache-server
```

### **View Deployments:**
```bash
# List deployments
kubectl get deployments -n apache-server

# Describe deployment
kubectl describe deployment apache2-deployment -n apache-server
```

### **View ConfigMaps:**
```bash
# List configmaps
kubectl get configmaps -n apache-server

# View configmap content
kubectl describe configmap apache-config -n apache-server
```

### **View Logs:**
```bash
# Logs from all apache2 pods
kubectl logs -l app=apache2 -n apache-server

# Logs from specific pod
kubectl logs <pod-name> -n apache-server

# Follow logs in real-time
kubectl logs -f -l app=apache2 -n apache-server

# Last 50 lines
kubectl logs -l app=apache2 -n apache-server --tail=50
```

### **Execute Commands Inside Pod:**
```bash
# Get shell access
kubectl exec -it <pod-name> -n apache-server -- /bin/bash

# Run single command
kubectl exec <pod-name> -n apache-server -- ls /usr/local/apache2/htdocs

# Check Apache version
kubectl exec <pod-name> -n apache-server -- httpd -v
```

### **Port Forwarding (Alternative Access):**
```bash
# Forward local port 8080 to pod port 80
kubectl port-forward -n apache-server deployment/apache2-deployment 8080:80

# Then access at: http://localhost:8080
```

### **Scaling:**
```bash
# Scale to 5 replicas
kubectl scale deployment apache2-deployment -n apache-server --replicas=5

# Check status
kubectl get pods -n apache-server
```

### **Update Deployment:**
```bash
# Edit deployment
kubectl edit deployment apache2-deployment -n apache-server

# Restart deployment (rolling restart)
kubectl rollout restart deployment apache2-deployment -n apache-server

# Check rollout status
kubectl rollout status deployment apache2-deployment -n apache-server
```

### **Get Resource Usage:**
```bash
# Pod resource usage
kubectl top pods -n apache-server

# Node resource usage
kubectl top nodes
```

---

## 🔍 Verification Commands

### **Check if Everything is Running:**
```bash
# All resources
kubectl get all -n apache-server

# Expected output:
# - 3 pods (apache2-deployment-xxx)
# - 1 deployment (apache2-deployment)
# - 1 replicaset
# - 1 service (apache2-service)
```

### **Verify Pods are Ready:**
```bash
kubectl get pods -n apache-server

# All pods should show: READY 1/1, STATUS Running
```

### **Test Service:**
```bash
# From command line
curl http://localhost:30090

# Should return HTML content
```

### **Check Pod Health:**
```bash
kubectl describe pod <pod-name> -n apache-server

# Look for:
# - Liveness probe: Success
# - Readiness probe: Success
# - Events: No errors
```


## 🧪 Testing the Server

### **Test 1: Basic Access**
```bash
curl http://localhost:30090
```
**Expected:** HTML content displayed

### **Test 2: Multiple Requests (Load Balancing)**
```bash
for i in {1..10}; do
  curl -s http://localhost:30090 | grep -o "Apache2 Server"
done
```
**Expected:** All requests succeed

### **Test 3: Service Availability**
```bash
kubectl get endpoints -n apache-server
```
**Expected:** 3 endpoints (one for each pod)

### **Test 4: Health Checks**
```bash
kubectl get pods -n apache-server
```
**Expected:** All pods show READY 1/1

---

## 🔧 Troubleshooting

### **Pods Not Starting?**
```bash
kubectl describe pod <pod-name> -n apache-server
kubectl logs <pod-name> -n apache-server
```

### **Can't Access Service?**
```bash
# Check service
kubectl get svc -n apache-server

# Check if NodePort is correct
kubectl describe svc apache2-service -n apache-server

# Test from inside cluster
kubectl run test-pod --image=busybox -n apache-server --rm -it -- wget -O- http://apache2-service
```

### **ConfigMap Issues?**
```bash
# View configmap
kubectl get configmap apache-config -n apache-server -o yaml

# Check if mounted correctly
kubectl exec <pod-name> -n apache-server -- cat /usr/local/apache2/htdocs/index.html
```

---

## 🗑️ Cleanup

### **Delete Everything:**
```bash
kubectl delete namespace apache-server
```

### **Delete Individual Resources:**
```bash
kubectl delete -f 03-service.yml
kubectl delete -f 02-deployment.yml
kubectl delete -f 01-configmap.yml
kubectl delete -f 00-namespace.yml
```

---

## 📝 Lab Report Summary

**Project:** Apache2 Server Deployment on Kubernetes

**Objectives:**
- ✅ Deploy Apache2 web server in Kubernetes
- ✅ Access server from host machine
- ✅ Use Kubernetes commands effectively
- ✅ Configure custom content using ConfigMap
- ✅ Implement high availability with replicas

**Components Deployed:**
- 1 Namespace (apache-server)
- 1 ConfigMap (custom HTML + Apache config)
- 1 Deployment (3 replicas)
- 1 Service (NodePort on 30090)

**Total Pods:** 3 (for high availability)

**Access Method:** NodePort service on port 30090

**Commands Used:**
- `kubectl apply` - Deploy resources
- `kubectl get` - View resources
- `kubectl describe` - Detailed information
- `kubectl logs` - View logs
- `kubectl exec` - Execute commands in pods
- `kubectl scale` - Scale replicas
- `curl` - Test HTTP access

**Status:** ✅ Fully Operational

---

## 🎓 Key Kubernetes Concepts Demonstrated

✅ **Deployments** - Manage replica sets  
✅ **Services** - Expose applications (NodePort)  
✅ **ConfigMaps** - Configuration management  
✅ **Namespaces** - Resource isolation  
✅ **Labels & Selectors** - Resource organization  
✅ **Health Probes** - Liveness and readiness  
✅ **Resource Limits** - CPU and memory constraints  
✅ **Scaling** - Horizontal pod scaling  

---

