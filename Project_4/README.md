
2# Retail Store Application - Docker Deployment

## Run the Project

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## Test the Application

```bash
# Check health
curl http://localhost:8090/health

# Get all products
curl http://localhost:8090/api/products

# Test load balancer
curl http://localhost:8080/health
```

## Access URLs

- Main Application: http://localhost:8090
- Load Balancer: http://localhost:8080
- Replica 1: http://localhost:8091
- Replica 2: http://localhost:8092
- Grafana: http://localhost:3000 (admin/admin123)
- Prometheus: http://localhost:9090

## Stop Services

```bash
docker-compose down
```