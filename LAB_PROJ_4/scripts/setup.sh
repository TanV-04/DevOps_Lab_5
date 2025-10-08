#!/bin/bash

# Jenkins Distributed Pipeline Setup Script
# This script sets up the entire Jenkins infrastructure with Docker

set -e  # Exit on any error

echo "=== Jenkins Distributed Pipeline Setup ==="
echo "Setting up Jenkins master with distributed slave nodes..."

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if ports are available
if netstat -tuln | grep -q ":8080 "; then
    echo "⚠️  Port 8080 is already in use. Please stop the service using it or change the port."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

if netstat -tuln | grep -q ":50000 "; then
    echo "⚠️  Port 50000 is already in use. Please stop the service using it or change the port."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✅ Prerequisites check passed"

# Navigate to docker directory
cd "$(dirname "$0")/../docker" || exit 1

echo "Starting Jenkins infrastructure..."

# Pull latest images
echo "📥 Pulling Docker images..."
docker-compose pull

# Build custom slave images
echo "🏗️  Building Jenkins slave images..."
docker-compose build --no-cache

# Start services
echo "🚀 Starting Jenkins services..."
docker-compose up -d

echo "⏳ Waiting for services to start..."
sleep 30

# Check service health
echo "🔍 Checking service health..."
if docker-compose ps | grep -q "jenkins-master.*Up"; then
    echo "✅ Jenkins Master: Running"
else
    echo "❌ Jenkins Master: Failed to start"
    docker-compose logs jenkins-master
    exit 1
fi

# Wait for Jenkins to be fully ready
echo "⏳ Waiting for Jenkins to initialize (this may take a few minutes)..."
timeout=300  # 5 minutes timeout
counter=0

while ! curl -s http://localhost:8080/login > /dev/null; do
    sleep 10
    counter=$((counter + 10))
    if [ $counter -ge $timeout ]; then
        echo "❌ Timeout waiting for Jenkins to start"
        echo "Check the logs with: docker-compose logs jenkins-master"
        exit 1
    fi
    echo "Still waiting... (${counter}s/${timeout}s)"
done

echo "✅ Jenkins Master is ready!"

# Check slave connections
echo "🔍 Checking slave node connections..."
sleep 20  # Give slaves time to connect

if docker-compose ps | grep -q "jenkins-slave-compile.*Up"; then
    echo "✅ Compile Node: Running"
else
    echo "⚠️  Compile Node: Not running properly"
    echo "Check logs with: docker-compose logs jenkins-slave-compile"
fi

if docker-compose ps | grep -q "jenkins-slave-test.*Up"; then
    echo "✅ Test Node: Running"
else
    echo "⚠️  Test Node: Not running properly"
    echo "Check logs with: docker-compose logs jenkins-slave-test"
fi

# Display connection information
echo ""
echo "🎉 === Setup Complete! ==="
echo ""
echo "Access Information:"
echo "📱 Jenkins URL: http://localhost:8080"
echo "👤 Username: admin"
echo "🔑 Password: admin123"
echo ""
echo "Node Configuration:"
echo "🖥️  Master Node: jenkins-master (orchestration)"
echo "⚙️  Compile Node: compile-node (compilation & packaging)"
echo "🧪 Test Node: test-node (testing & quality analysis)"
echo ""
echo "Next Steps:"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Login with admin/admin123"
echo "3. Create a new Pipeline job"
echo "4. Use the Jenkinsfile from this project"
echo "5. Run the distributed pipeline!"
echo ""
echo "Useful Commands:"
echo "📊 Check status: docker-compose ps"
echo "📋 View logs: docker-compose logs [service-name]"
echo "🛑 Stop services: docker-compose down"
echo "🔄 Restart services: docker-compose restart"
echo ""
echo "For detailed setup instructions, see: docs/SETUP_GUIDE.md"

# Create a simple pipeline job automatically (if possible)
echo ""
echo "Would you like to create a sample pipeline job automatically? (y/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏗️  Creating sample pipeline job..."
    
    # Create job config XML
    cat > /tmp/pipeline-job.xml << 'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.40">
  <description>Distributed Maven Pipeline Demo - Compiles on compile-node and tests on test-node</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps@2.92">
    <script>
pipeline {
    agent none
    
    stages {
        stage('Demo Info') {
            agent any
            steps {
                echo "=== Jenkins Distributed Pipeline Demo ==="
                echo "This pipeline demonstrates distributed builds across multiple nodes"
                echo "- Compilation will run on: compile-node"
                echo "- Testing will run on: test-node"
            }
        }
        
        stage('Compile') {
            agent {
                label 'compile-node'
            }
            steps {
                echo "🏗️ Compiling on compile-node: \${NODE_NAME}"
                sh 'java -version'
                sh 'mvn --version || echo "Maven will be available in real scenario"'
                echo "Compilation would happen here in a real project"
            }
        }
        
        stage('Test') {
            agent {
                label 'test-node'  
            }
            steps {
                echo "🧪 Testing on test-node: \${NODE_NAME}"
                sh 'java -version'
                sh 'mvn --version || echo "Maven will be available in real scenario"'
                echo "Testing would happen here in a real project"
            }
        }
        
        stage('Summary') {
            agent any
            steps {
                echo "✅ Pipeline completed successfully!"
                echo "Demonstrated distributed execution across specialized nodes"
            }
        }
    }
}
    </script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF
    
    # Try to create the job via Jenkins CLI
    if curl -s -f -X POST "http://admin:admin123@localhost:8080/createItem?name=distributed-pipeline-demo" \
        -H "Content-Type: application/xml" \
        --data-binary @/tmp/pipeline-job.xml > /dev/null 2>&1; then
        echo "✅ Sample pipeline job created: 'distributed-pipeline-demo'"
        echo "You can run it immediately from the Jenkins web interface!"
    else
        echo "⚠️  Automatic job creation failed. You can create it manually using the Jenkinsfile."
    fi
    
    rm -f /tmp/pipeline-job.xml
fi

echo ""
echo "🚀 Jenkins Distributed Pipeline is ready for use!"
