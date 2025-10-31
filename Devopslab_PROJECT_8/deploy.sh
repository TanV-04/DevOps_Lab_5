#!/bin/bash

echo "=========================================="
echo "E-Commerce Microservices Deployment"
echo "Project 8: Complete 4-Microservice Application"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl not found${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Checking Kubernetes cluster...${NC}"
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ Cannot connect to cluster${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Cluster is accessible${NC}"
echo ""

# Step 1: Create Namespace
echo -e "${BLUE}📝 Step 1/11: Creating Namespace...${NC}"
kubectl apply -f 00-namespace.yml
echo -e "${GREEN}✅ Namespace created${NC}"
echo ""
sleep 2

# Step 2: Create Secrets
echo -e "${BLUE}📝 Step 2/11: Creating Secrets...${NC}"
kubectl apply -f 01-secrets.yml
echo -e "${GREEN}✅ Secrets created${NC}"
echo ""
sleep 2

# Step 3: Create ConfigMaps
echo -e "${BLUE}📝 Step 3/11: Creating ConfigMaps...${NC}"
kubectl apply -f 02-configmaps.yml
echo -e "${GREEN}✅ ConfigMaps created${NC}"
echo ""
sleep 2

# Step 4: Create PVC
echo -e "${BLUE}📝 Step 4/11: Creating PersistentVolumeClaim...${NC}"
kubectl apply -f 03-pvc.yml
echo -e "${GREEN}✅ PVC created${NC}"
echo ""
sleep 2

# Step 5: Deploy MongoDB
echo -e "${BLUE}📝 Step 5/11: Deploying MongoDB...${NC}"
kubectl apply -f 04-mongodb-deployment.yml
kubectl apply -f 05-mongodb-service.yml
echo -e "${GREEN}✅ MongoDB deployed${NC}"
echo ""

# Wait for MongoDB
echo -e "${YELLOW}⏳ Waiting for MongoDB to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=mongodb -n ecommerce --timeout=120s
echo -e "${GREEN}✅ MongoDB is ready${NC}"
echo ""

# Step 6: Deploy Product Service
echo -e "${BLUE}📝 Step 6/11: Deploying Product Service...${NC}"
kubectl apply -f 06-product-service-deployment.yml
kubectl apply -f 07-product-service-service.yml
echo -e "${GREEN}✅ Product Service deployed${NC}"
echo ""

# Step 7: Deploy Order Service
echo -e "${BLUE}📝 Step 7/11: Deploying Order Service...${NC}"
kubectl apply -f 08-order-service-deployment.yml
kubectl apply -f 09-order-service-service.yml
echo -e "${GREEN}✅ Order Service deployed${NC}"
echo ""

# Step 8: Deploy Frontend
echo -e "${BLUE}📝 Step 8/11: Deploying Frontend...${NC}"
kubectl apply -f 10-frontend-deployment.yml
kubectl apply -f 11-frontend-service.yml
echo -e "${GREEN}✅ Frontend deployed${NC}"
echo ""

# Wait for all services
echo -e "${YELLOW}⏳ Waiting for all services to be ready...${NC}"
sleep 30
echo ""

# Display status
echo -e "${BLUE}📊 Deployment Status${NC}"
echo "=========================================="
echo ""
echo -e "${BLUE}Pods:${NC}"
kubectl get pods -n ecommerce
echo ""
echo -e "${BLUE}Services:${NC}"
kubectl get services -n ecommerce
echo ""

# Access instructions
echo "=========================================="
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "=========================================="
echo ""
echo -e "${BLUE}📱 Access the Application:${NC}"
echo ""
echo "  🌐 Frontend URL: http://localhost:30080"
echo ""
echo -e "${GREEN}✨ Your microservices application is ready!${NC}"
echo ""
