# 🏗️ Architecture Diagram - Project 8

## Complete System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         INTERNET/USER                                │
│                    http://localhost:30080                            │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                │ HTTP Request
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                          KUBERNETES CLUSTER                          │
│                          Namespace: ecommerce                        │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              Frontend Service (NodePort: 30080)               │  │
│  │                  Exposes Port 80 → 30080                      │  │
│  └────────────────────────┬─────────────────────────────────────┘  │
│                           │                                          │
│                           │ Routes to                                │
│                           ↓                                          │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │            Frontend Deployment (Nginx)                        │  │
│  │              Pod 1           Pod 2                            │  │
│  │            [Nginx:80]      [Nginx:80]                         │  │
│  │            Replicas: 2                                        │  │
│  │            - Serves static HTML/CSS/JS                        │  │
│  │            - Reverse proxy to backend                         │  │
│  │            - Health checks: /, port 80                        │  │
│  └────────┬──────────────────────────────┬────────────────────────┘  │
│           │                              │                           │
│           │ API Calls                    │ API Calls                 │
│           ↓                              ↓                           │
│  ┌─────────────────────┐       ┌─────────────────────┐             │
│  │  Product Service    │       │   Order Service     │             │
│  │   (ClusterIP:3001)  │       │  (ClusterIP:3002)   │             │
│  └──────────┬──────────┘       └──────────┬──────────┘             │
│             │                              │                         │
│             ↓                              ↓                         │
│  ┌─────────────────────┐       ┌─────────────────────┐             │
│  │ Product Deployment  │       │  Order Deployment   │             │
│  │   Pod 1  │  Pod 2   │       │   Pod 1  │  Pod 2   │             │
│  │ [Node:  │ [Node:    │       │ [Node:  │ [Node:    │             │
│  │  3001]  │  3001]    │       │  3002]  │  3002]    │             │
│  │ Replicas: 2         │       │ Replicas: 2         │             │
│  │ - Product CRUD      │       │ - Order CRUD        │             │
│  │ - Health: /health   │       │ - Health: /health   │             │
│  │ - Uses ConfigMap    │       │ - Uses ConfigMap    │             │
│  │ - Uses Secrets      │       │ - Uses Secrets      │             │
│  └──────────┬──────────┘       └──────────┬──────────┘             │
│             │                              │                         │
│             │ DB Queries                   │ DB Queries              │
│             └──────────┬───────────────────┘                         │
│                        │                                             │
│                        ↓                                             │
│            ┌──────────────────────────┐                             │
│            │   MongoDB Service        │                             │
│            │   (ClusterIP:27017)      │                             │
│            └─────────────┬────────────┘                             │
│                          │                                           │
│                          ↓                                           │
│            ┌──────────────────────────┐                             │
│            │  MongoDB Deployment      │                             │
│            │      [MongoDB:27017]     │                             │
│            │      Replicas: 1         │                             │
│            │  - Database storage      │                             │
│            │  - Uses Secrets for auth │                             │
│            │  - Health: port 27017    │                             │
│            └─────────────┬────────────┘                             │
│                          │                                           │
│                          ↓                                           │
│            ┌──────────────────────────┐                             │
│            │ PersistentVolumeClaim    │                             │
│            │   mongodb-pvc (2Gi)      │                             │
│            │   /data/db               │                             │
│            │   StorageClass: hostpath │                             │
│            └──────────────────────────┘                             │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    Configuration Layer                        │  │
│  │                                                                │  │
│  │  ConfigMaps:                    Secrets:                      │  │
│  │  ├─ app-config                  ├─ db-secret                  │  │
│  │  │  ├─ DB_HOST                  │  ├─ username: dbadmin       │  │
│  │  │  ├─ DB_PORT                  │  └─ password: dbpass123     │  │
│  │  │  ├─ DB_NAME: ecommerce       │                             │  │
│  │  │  ├─ APP_ENV: production      ├─ app-secret                 │  │
│  │  │  └─ Service URLs             │  ├─ api-key                 │  │
│  │  │                               │  └─ jwt-secret              │  │
│  │  └─ nginx-config                │                             │  │
│  │     └─ Reverse proxy rules      │                             │  │
│  └──────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────┘
```

## Resource Summary

### Deployments (4)
- **MongoDB**: 1 pod
- **Product Service**: 2 pods  
- **Order Service**: 2 pods
- **Frontend**: 2 pods

**Total Pods: 7**

### Services (4)
- **frontend-service**: NodePort (30080)
- **product-service**: ClusterIP (3001)
- **order-service**: ClusterIP (3002)
- **mongodb-service**: ClusterIP (27017)

### Configuration (4)
- **Namespace**: ecommerce
- **Secrets**: 2 (db-secret, app-secret)
- **ConfigMaps**: 2 (app-config, nginx-config)
- **PVC**: 1 (mongodb-pvc, 2Gi)

## Data Flow

### User Request Flow:
```
User Browser
    ↓ (http://localhost:30080)
Frontend Service (NodePort)
    ↓
Frontend Pod (Nginx)
    ↓ (proxy /api/products)
Product Service
    ↓
Product Pod (Node.js)
    ↓ (MongoDB query)
MongoDB Service
    ↓
MongoDB Pod
    ↓
Persistent Volume
```

### Inter-Service Communication:
```
Product Service ←→ MongoDB (via mongodb-service:27017)
Order Service   ←→ MongoDB (via mongodb-service:27017)
Frontend        ←→ Product Service (via product-service:3001)
Frontend        ←→ Order Service (via order-service:3002)
```

## Network Policies

### External Access:
- **Frontend**: Port 30080 (NodePort) - Public
- **Product API**: Port 3001 (ClusterIP) - Internal only
- **Order API**: Port 3002 (ClusterIP) - Internal only
- **MongoDB**: Port 27017 (ClusterIP) - Internal only

### Security:
- Credentials stored in Secrets (base64 encoded)
- ConfigMaps for non-sensitive configuration
- Services use internal DNS (service-name.namespace.svc.cluster.local)

## High Availability

### Load Balancing:
- Frontend: 2 replicas → Load balanced by Service
- Product Service: 2 replicas → Load balanced by Service
- Order Service: 2 replicas → Load balanced by Service

### Health Checks:
- **Liveness Probes**: Detect if pod is alive
- **Readiness Probes**: Detect if pod can serve traffic
- **Endpoints**: /health for backend services, / for frontend

## Storage

### Persistent Data:
- MongoDB data stored in PVC (2Gi)
- Survives pod restarts/deletions
- Mounted at /data/db in MongoDB container

### Ephemeral Data:
- Frontend static files (in container)
- Backend application code (in container)
- Logs (cleared on pod deletion)

## Scaling

### Current Setup:
- Frontend: 2 replicas (can handle more traffic)
- Product Service: 2 replicas (can scale up)
- Order Service: 2 replicas (can scale up)
- MongoDB: 1 replica (stateful, requires special scaling)

### How to Scale:
```bash
# Scale Product Service to 3 replicas
kubectl scale deployment product-service -n ecommerce --replicas=3

# Scale Order Service to 4 replicas
kubectl scale deployment order-service -n ecommerce --replicas=4
```

## Monitoring Points

### Health Endpoints:
- Product Service: http://product-service:3001/health
- Order Service: http://order-service:3002/health
- Frontend: http://frontend-service/ (root path)
- MongoDB: TCP connection on port 27017

### Log Locations:
```bash
kubectl logs -l app=frontend -n ecommerce
kubectl logs -l app=product-service -n ecommerce
kubectl logs -l app=order-service -n ecommerce
kubectl logs -l app=mongodb -n ecommerce
```

---

**This architecture demonstrates a production-ready microservices setup with:**
- ✅ Service isolation
- ✅ Load balancing
- ✅ High availability
- ✅ Persistent storage
- ✅ Configuration management
- ✅ Secret management
- ✅ Health monitoring
- ✅ Horizontal scalability
