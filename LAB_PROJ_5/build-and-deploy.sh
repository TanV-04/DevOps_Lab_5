#!/bin/bash

# Build and Deploy Script for Retail Application
# Project 5: Containerizing application and scanning its Docker image with DTR

set -e

echo "🏪 Retail Application - Build and Deploy Script"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="retail-app"
IMAGE_TAG="latest"
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"localhost:5000"}

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed or not in PATH"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Build application
build_application() {
    log_info "Building Spring Boot application..."
    
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        # Windows
        ./mvnw.cmd clean package -DskipTests
    else
        # Linux/Mac
        chmod +x mvnw
        ./mvnw clean package -DskipTests
    fi
    
    log_success "Application built successfully"
}

# Build Docker image
build_docker_image() {
    log_info "Building Docker image: $APP_NAME:$IMAGE_TAG"
    
    docker build -t $APP_NAME:$IMAGE_TAG .
    
    log_success "Docker image built successfully"
}

# Scan Docker image for vulnerabilities
scan_docker_image() {
    log_info "Scanning Docker image for vulnerabilities..."
    
    # Try different scanning tools
    if command -v docker scout &> /dev/null; then
        log_info "Using Docker Scout for vulnerability scanning..."
        docker scout cves $APP_NAME:$IMAGE_TAG || log_warning "Docker Scout scan failed"
    elif command -v trivy &> /dev/null; then
        log_info "Using Trivy for vulnerability scanning..."
        trivy image $APP_NAME:$IMAGE_TAG || log_warning "Trivy scan failed"
    else
        log_warning "No vulnerability scanner found. Install Docker Scout or Trivy for security scanning."
    fi
}

# Deploy with Docker Compose
deploy_application() {
    log_info "Deploying application with Docker Compose..."
    
    # Stop existing services
    docker-compose down 2>/dev/null || true
    
    # Start services
    docker-compose up -d
    
    log_success "Application deployed successfully"
}

# Wait for services to be healthy
wait_for_services() {
    log_info "Waiting for services to become healthy..."
    
    max_attempts=30
    attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s http://localhost:8080/health > /dev/null 2>&1; then
            log_success "Application is healthy and ready!"
            break
        else
            log_info "Attempt $attempt/$max_attempts: Waiting for application to start..."
            sleep 10
            ((attempt++))
        fi
    done
    
    if [ $attempt -gt $max_attempts ]; then
        log_error "Application failed to become healthy within expected time"
        exit 1
    fi
}

# Show application info
show_application_info() {
    log_success "🎉 Deployment completed successfully!"
    echo ""
    echo "📊 Service URLs:"
    echo "  Main Application:     http://localhost:8080"
    echo "  Load Balancer:        http://localhost"
    echo "  Application Replica 1: http://localhost:8081"
    echo "  Application Replica 2: http://localhost:8082"
    echo "  Grafana Dashboard:    http://localhost:3000 (admin/admin123)"
    echo "  Prometheus:           http://localhost:9090"
    echo ""
    echo "🔍 API Endpoints:"
    echo "  Products API:         http://localhost:8080/api/products"
    echo "  Health Check:         http://localhost:8080/health"
    echo "  Application Info:     http://localhost:8080/"
    echo ""
    echo "🐳 Docker Commands:"
    echo "  View logs:            docker-compose logs -f"
    echo "  Check status:         docker-compose ps"
    echo "  Stop services:        docker-compose down"
    echo ""
}

# Clean up function
cleanup() {
    log_info "Cleaning up..."
    docker-compose down 2>/dev/null || true
    log_success "Cleanup completed"
}

# Main execution
main() {
    case "${1:-deploy}" in
        "build")
            check_prerequisites
            build_application
            build_docker_image
            ;;
        "scan")
            scan_docker_image
            ;;
        "deploy")
            check_prerequisites
            build_application
            build_docker_image
            scan_docker_image
            deploy_application
            wait_for_services
            show_application_info
            ;;
        "cleanup")
            cleanup
            ;;
        "help")
            echo "Usage: $0 [build|scan|deploy|cleanup|help]"
            echo ""
            echo "Commands:"
            echo "  build    - Build application and Docker image only"
            echo "  scan     - Scan Docker image for vulnerabilities"
            echo "  deploy   - Full deployment (build + scan + deploy)"
            echo "  cleanup  - Stop and remove all services"
            echo "  help     - Show this help message"
            ;;
        *)
            log_error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Trap to cleanup on script exit
trap cleanup EXIT

# Run main function
main "$@"