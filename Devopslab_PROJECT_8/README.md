# 🚀 Project 8: Complete Microservices Application

## 📦 What's Inside

This project deploys a complete **4-microservice e-commerce application** on Kubernetes:

### **The 4 Microservices:**

1. **🗄️ MongoDB Database**
   - Persistent storage (2Gi PVC)
   - Port: 27017
   - Replicas: 1

2. **📦 Product Service** 
   - Node.js REST API
   - Port: 3001
   - Replicas: 2
   - Endpoints: /products, /health

3. **🛍️ Order Service**
   - Node.js REST API
   - Port: 3002
   - Replicas: 2
   - Endpoints: /orders, /health

4. **💻 Frontend**
   - Nginx web interface
   - Port: 80 → NodePort 30080
   - Replicas: 2
   - Beautiful interactive UI

---

## 🎯 Quick Start

### **1. Deploy Everything (Easiest)**
```bash
chmod +x deploy.sh
./deploy.sh
```

### **2. Access the Application**
Open browser: **http://localhost:30080**

That's it! 🎉

---

## 📁 Files Included

### **Configuration Files:**
- `00-namespace.yml` - Creates 'ecommerce' namespace
- `01-secrets.yml` - Database & app credentials
- `02-configmaps.yml` - Application configuration
- `03-pvc.yml` - 2Gi persistent storage for MongoDB

### **Database:**
- `04-mongodb-deployment.yml` - MongoDB deployment
- `05-mongodb-service.yml` - MongoDB ClusterIP service

### **Product Service:**
- `06-product-service-deployment.yml` - Product API (2 replicas)
- `07-product-service-service.yml` - Product service

### **Order Service:**
- `08-order-service-deployment.yml` - Order API (2 replicas)
- `09-order-service-service.yml` - Order service

### **Frontend:**
- `10-frontend-deployment.yml` - Web UI (2 replicas)
- `11-frontend-service.yml` - Frontend NodePort (30080)

### **Documentation:**
- `DEPLOYMENT-GUIDE.md` - Detailed deployment steps
- `QUICK-REFERENCE.md` - Quick commands
- `deploy.sh` - Automated deployment script
- `README.md` - This file

---

## 🔑 Credentials

### **Database (in Secrets):**
- Username: `dbadmin`
- Password: `dbpass123`

### **API Keys (in Secrets):**
- API Key: `myapikey12345`
- JWT Secret: `jwtsecret123`

*All stored securely in Kubernetes Secrets (base64 encoded)*

---

## 🧪 Testing the APIs

### **Product Service:**
```bash
kubectl port-forward -n ecommerce svc/product-service 3001:3001

# Get all products
curl http://localhost:3001/products

# Get product by ID
curl http://localhost:3001/products/1

# Health check
curl http://localhost:3001/health
```

### **Order Service:**
```bash
kubectl port-forward -n ecommerce svc/order-service 3002:3002

# Get all orders
curl http://localhost:3002/orders

# Get order by ID
curl http://localhost:3002/orders/1

# Health check
curl http://localhost:3002/health
```

---

## 📊 Monitoring

### **View All Resources:**
```bash
kubectl get all -n ecommerce
```

### **Check Pod Status:**
```bash
kubectl get pods -n ecommerce
```

### **View Logs:**
```bash
# Product Service
kubectl logs -l app=product-service -n ecommerce

# Order Service
kubectl logs -l app=order-service -n ecommerce

# Frontend
kubectl logs -l app=frontend -n ecommerce

# MongoDB
kubectl logs -l app=mongodb -n ecommerce
```

### **Follow Logs in Real-Time:**
```bash
kubectl logs -f -l app=product-service -n ecommerce
```

---

## 🏗️ Architecture

```
┌──────────────────────────────────────┐
│         User Browser                  │
│     http://localhost:30080            │
└─────────────┬────────────────────────┘
              │
              ↓
┌─────────────────────────────────────┐
│   Frontend (Nginx) - NodePort:30080 │
│          Replicas: 2                │
└──────┬──────────────────────┬───────┘
       │                      │
       ↓                      ↓
┌──────────────┐      ┌──────────────┐
│   Product    │      │    Order     │
│   Service    │      │   Service    │
│  Port: 3001  │      │  Port: 3002  │
│ Replicas: 2  │      │ Replicas: 2  │
└──────┬───────┘      └──────┬───────┘
       │                     │
       └──────────┬──────────┘
                  ↓
         ┌────────────────┐
         │    MongoDB     │
         │  Port: 27017   │
         │  Replicas: 1   │
         │   PVC: 2Gi     │
         └────────────────┘
```

---

## ✅ What You'll Learn

### **Kubernetes Concepts:**
- ✅ Namespaces
- ✅ Deployments (with replicas)
- ✅ Services (ClusterIP & NodePort)
- ✅ ConfigMaps
- ✅ Secrets
- ✅ PersistentVolumeClaims
- ✅ Resource Limits
- ✅ Health Checks (Liveness & Readiness Probes)
- ✅ Labels & Selectors

### **Microservices Patterns:**
- ✅ Service Discovery
- ✅ API Gateway Pattern
- ✅ Configuration Management
- ✅ Secret Management
- ✅ Persistent Storage
- ✅ High Availability (Multiple Replicas)

---

## 🗑️ Cleanup

### **Delete Everything:**
```bash
kubectl delete namespace ecommerce
```

This removes all resources in one command!

---

## 📸 For Your Lab Report

**Take Screenshots of:**

1. **Deployment Status:**
   ```bash
   kubectl get all -n ecommerce
   ```

2. **Pods Running:**
   ```bash
   kubectl get pods -n ecommerce
   ```

3. **Services:**
   ```bash
   kubectl get services -n ecommerce
   ```

4. **ConfigMaps & Secrets:**
   ```bash
   kubectl get cm,secrets -n ecommerce
   ```

5. **Frontend UI:**
   - Open http://localhost:30080
   - Screenshot the web interface

6. **API Responses:**
   - Test Product API
   - Test Order API
   - Screenshot responses

---

## 📝 Project Summary

**Components Deployed:**
- 1 Namespace (`ecommerce`)
- 2 Secrets (db-secret, app-secret)
- 2 ConfigMaps (app-config, nginx-config)
- 1 PVC (2Gi for MongoDB)
- 4 Deployments:
  - MongoDB (1 replica)
  - Product Service (2 replicas)
  - Order Service (2 replicas)
  - Frontend (2 replicas)
- 4 Services (1 NodePort, 3 ClusterIP)

**Total Pods:** 7 (1+2+2+2)

**Access URL:** http://localhost:30080

---

## 🎓 Success Criteria

✅ All 7 pods are running  
✅ All 4 services are created  
✅ Frontend is accessible at port 30080  
✅ Product API responds at port 3001  
✅ Order API responds at port 3002  
✅ MongoDB is storing data persistently  
✅ Health checks are passing  
✅ Multiple replicas for high availability  

---

## 💡 Tips

1. **If pods are pending:** Wait 1-2 minutes for images to download
2. **If services don't respond:** Check logs with `kubectl logs`
3. **If PVC is pending:** Docker Desktop auto-provisions storage
4. **Port already in use:** Change NodePort in `11-frontend-service.yml`

---

## 🎉 Congratulations!

You've deployed a complete, production-ready microservices application on Kubernetes!

This demonstrates:
- Multi-tier architecture
- Service-to-service communication
- Configuration & secret management
- Persistent data storage
- High availability
- Load balancing
- Health monitoring

**Your DevOps Lab Project 8 is Complete!** 🚀

---

## 📞 Need Help?

Check these files:
- **Quick commands:** `QUICK-REFERENCE.md`
- **Detailed steps:** `DEPLOYMENT-GUIDE.md`
- **Run script:** `./deploy.sh`

Good luck with your lab! 🎓
