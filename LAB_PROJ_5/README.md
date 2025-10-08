# Retail Store Application - Docker Deployment

A Spring Boot retail application designed for containerization and deployment with Docker, featuring multiple web application instances and comprehensive monitoring.

## 🏪 Project Overview

This project demonstrates:
- **Spring Boot Application**: RESTful retail management system
- **Docker Containerization**: Multi-stage Docker build for optimization
- **Load Balancing**: Nginx-based load balancer with multiple app instances
- **Monitoring**: Prometheus and Grafana integration
- **Security**: Docker image scanning with DTR capabilities

## 🚀 Features

### Application Features
- **Product Management**: CRUD operations for retail products
- **Category-based Filtering**: Products organized by categories
- **Search Functionality**: Product search by name and price range
- **Stock Management**: Track inventory levels
- **RESTful API**: JSON-based API endpoints
- **Health Checks**: Built-in health monitoring

### Infrastructure Features
- **Multi-instance Deployment**: 3 application replicas
- **Load Balancing**: Nginx with round-robin distribution
- **Service Discovery**: Docker network-based communication
- **Monitoring Stack**: Prometheus metrics + Grafana dashboards
- **Caching**: Redis integration ready
- **Security**: Non-root container execution

## 📁 Project Structure

```
Project_4/
├── src/
│   └── main/
│       ├── java/com/retail/
│       │   ├── RetailApplication.java
│       │   ├── config/DataInitializer.java
│       │   ├── controller/
│       │   │   ├── HomeController.java
│       │   │   └── ProductController.java
│       │   ├── model/Product.java
│       │   ├── repository/ProductRepository.java
│       │   └── service/ProductService.java
│       └── resources/
│           └── application.properties
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── prometheus.yml
├── pom.xml
└── README.md
```

## 🛠️ Prerequisites

- **Java 17+**
- **Maven 3.6+**
- **Docker 20.10+**
- **Docker Compose 2.0+**

## 🚀 Quick Start

### 1. Clone and Build

```bash
# Navigate to project directory
cd Project_4

# Build the application (Linux/Mac)
./mvnw clean package -DskipTests

# For Windows
mvnw.cmd clean package -DskipTests
```

### 2. Run with Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f retail-app

# Check status
docker-compose ps
```

### 3. Access the Application

- **Main Application**: http://localhost:8080
- **Load Balancer**: http://localhost (port 80)
- **Grafana Dashboard**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Application Replicas**:
  - Replica 1: http://localhost:8081
  - Replica 2: http://localhost:8082

## 📊 API Endpoints

### Product Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/products` | Get all products |
| GET | `/api/products/{id}` | Get product by ID |
| GET | `/api/products/category/{category}` | Get products by category |
| GET | `/api/products/search?name={name}` | Search products by name |
| GET | `/api/products/price-range?minPrice={min}&maxPrice={max}` | Filter by price range |
| GET | `/api/products/available` | Get products in stock |
| POST | `/api/products` | Create new product |
| PUT | `/api/products/{id}` | Update product |
| DELETE | `/api/products/{id}` | Delete product |

### System Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Application info |
| GET | `/health` | Health check |
| GET | `/actuator/health` | Detailed health |
| GET | `/actuator/metrics` | Application metrics |

## 📝 Sample API Calls

### Get All Products
```bash
curl -X GET http://localhost:8080/api/products
```

### Create a Product
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Gaming Laptop",
    "description": "High-performance gaming laptop",
    "price": 1299.99,
    "stockQuantity": 5,
    "category": "Electronics"
  }'
```

### Search Products
```bash
curl -X GET "http://localhost:8080/api/products/search?name=laptop"
```

## 🐳 Docker Commands

### Build and Run Single Container

```bash
# Build the image
docker build -t retail-app .

# Run the container
docker run -p 8080:8080 retail-app
```

### Container Management

```bash
# View running containers
docker ps

# View logs
docker logs retail-app

# Execute commands in container
docker exec -it retail-app /bin/sh

# Stop all services
docker-compose down

# Remove all data
docker-compose down -v
```

## 🔍 Docker Image Scanning

### Using Docker Scout (Built-in)

```bash
# Scan the built image
docker scout cves retail-app

# Generate detailed report
docker scout recommendations retail-app
```

### Using Trivy

```bash
# Install Trivy
# For Linux
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan image
trivy image retail-app
```

### For DTR (Docker Trusted Registry)

```bash
# Tag for DTR
docker tag retail-app your-dtr-url/retail/retail-app:latest

# Push to DTR (enables automatic scanning)
docker push your-dtr-url/retail/retail-app:latest
```

## 📊 Monitoring

### Prometheus Metrics
- Application metrics: http://localhost:9090
- Custom metrics available at `/actuator/prometheus`

### Grafana Dashboards
- Access: http://localhost:3000
- Default credentials: admin/admin123
- Pre-configured to monitor Spring Boot applications

## 🔒 Security Features

- **Non-root container execution**
- **Multi-stage build** (reduces attack surface)
- **Health checks** for container orchestration
- **Rate limiting** via Nginx
- **Security headers** configured
- **Minimal base image** (OpenJDK slim)

## 🛠️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_PORT` | 8080 | Application port |
| `SPRING_PROFILES_ACTIVE` | default | Spring profile |
| `SPRING_DATASOURCE_URL` | H2 in-memory | Database URL |

### Production Configuration

```yaml
# docker-compose.override.yml
version: '3.8'
services:
  retail-app:
    environment:
      - SPRING_PROFILES_ACTIVE=production
      - JAVA_OPTS=-Xmx512m -Xms256m
```

## 🐛 Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 80, 3000, 8080-8082, 9090 are available
2. **Memory issues**: Increase Docker memory allocation
3. **Build failures**: Check Java/Maven versions

### Health Checks

```bash
# Check application health
curl http://localhost:8080/health

# Check via load balancer
curl http://localhost/health

# Docker health status
docker ps --format "table {{.Names}}\t{{.Status}}"
```

## 📈 Scaling

### Manual Scaling

```bash
# Scale retail app instances
docker-compose up -d --scale retail-app=5
```

### Production Deployment

- Use **Docker Swarm** or **Kubernetes** for orchestration
- Implement **external databases** (PostgreSQL/MySQL)
- Add **external caching** (Redis cluster)
- Configure **SSL/TLS** certificates
- Set up **log aggregation** (ELK stack)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is created for educational purposes as part of DevOps Project 5.

---

**Project 5**: Containerizing application and scanning its Docker image with DTR - Deploy a Spring Boot application on Docker for a retail company with multiple web applications.