
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

# Get product by ID
curl http://localhost:8090/api/products/1

# Search products by name
curl "http://localhost:8090/api/products/search?name=laptop"

# Get products by category
curl http://localhost:8090/api/products/category/Electronics

# Get products in price range
curl "http://localhost:8090/api/products/price-range?minPrice=50&maxPrice=1000"

# Get available products (in stock)
curl http://localhost:8090/api/products/available

# Create a new product
curl -X POST http://localhost:8090/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Gaming Mouse",
    "description": "High-precision gaming mouse",
    "price": 79.99,
    "stockQuantity": 25,
    "category": "Electronics"
  }'

# Update a product (replace ID with actual product ID)
curl -X PUT http://localhost:8090/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Laptop",
    "description": "Updated high-performance laptop",
    "price": 1199.99,
    "stockQuantity": 15,
    "category": "Electronics"
  }'

# Delete a product (replace ID with actual product ID)
curl -X DELETE http://localhost:8090/api/products/1

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