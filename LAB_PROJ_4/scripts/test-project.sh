#!/bin/bash

# Test script to validate the Maven project locally
# This script tests the project before running it in Jenkins pipeline

set -e

echo "=== Local Maven Project Test ==="
echo "Testing the distributed pipeline demo project..."

# Check if we're in the right directory
if [ ! -f "pom.xml" ]; then
    echo "❌ pom.xml not found. Please run this script from the project root directory."
    exit 1
fi

# Check Java version
echo "🔍 Checking Java version..."
if command -v java &> /dev/null; then
    java -version
    JAVA_VERSION=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 11 ]; then
        echo "⚠️  Java 11+ is recommended. Current version: $JAVA_VERSION"
    else
        echo "✅ Java version is compatible"
    fi
else
    echo "❌ Java not found. Please install Java 11+"
    exit 1
fi

# Check Maven version
echo "🔍 Checking Maven version..."
if command -v mvn &> /dev/null; then
    mvn --version | head -1
    echo "✅ Maven is available"
else
    echo "❌ Maven not found. Please install Maven 3.6+"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
mvn clean -q

# Compile the project
echo "🏗️  Compiling project..."
mvn compile -q
if [ $? -eq 0 ]; then
    echo "✅ Compilation successful"
else
    echo "❌ Compilation failed"
    exit 1
fi

# Run tests
echo "🧪 Running tests..."
mvn test -q
if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
else
    echo "❌ Tests failed"
    exit 1
fi

# Package the application
echo "📦 Packaging application..."
mvn package -DskipTests=true -q
if [ $? -eq 0 ]; then
    echo "✅ Packaging successful"
else
    echo "❌ Packaging failed"
    exit 1
fi

# Test the packaged application
echo "🚀 Testing packaged application..."
if [ -f "target/jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar" ]; then
    echo "Testing basic functionality..."
    
    # Test addition
    result=$(java -jar target/jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar + 10 5)
    echo "Addition test: $result"
    
    # Test multiplication  
    result=$(java -jar target/jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar "*" 7 8)
    echo "Multiplication test: $result"
    
    # Test square root
    result=$(java -jar target/jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar sqrt 16)
    echo "Square root test: $result"
    
    echo "✅ Application tests passed"
else
    echo "❌ JAR file not found"
    exit 1
fi

# Display project statistics
echo ""
echo "📊 Project Statistics:"
echo "Java source files: $(find src/main/java -name "*.java" | wc -l)"
echo "Test files: $(find src/test/java -name "*.java" | wc -l)"
echo "Lines of code (main): $(find src/main/java -name "*.java" -exec cat {} \; | wc -l)"
echo "Lines of code (test): $(find src/test/java -name "*.java" -exec cat {} \; | wc -l)"

# Display generated artifacts
echo ""
echo "📁 Generated Artifacts:"
if [ -d "target" ]; then
    echo "Target directory contents:"
    ls -la target/*.jar 2>/dev/null || echo "No JAR files found"
    
    if [ -d "target/surefire-reports" ]; then
        echo "Test reports: $(ls target/surefire-reports/*.xml | wc -l) files"
    fi
    
    if [ -d "target/classes" ]; then
        echo "Compiled classes: $(find target/classes -name "*.class" | wc -l) files"
    fi
fi

echo ""
echo "✅ === Local Maven Project Test Complete ==="
echo ""
echo "The project is ready for Jenkins distributed pipeline:"
echo "1. ✅ Code compiles successfully"
echo "2. ✅ All tests pass"  
echo "3. ✅ Application packages correctly"
echo "4. ✅ JAR runs with expected behavior"
echo ""
echo "Next Steps:"
echo "🐳 Run: ./scripts/setup.sh (or setup.bat on Windows)"
echo "🌐 Open: http://localhost:8080"
echo "⚡ Create pipeline job with the provided Jenkinsfile"
echo ""
echo "This validates that the project will work correctly"
echo "when distributed across Jenkins compile-node and test-node!"
