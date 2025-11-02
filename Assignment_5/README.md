# ☕ Java Spring Boot Maven Project

A simple **Spring Boot** application built using **Java 17** and **Maven**, featuring REST APIs, Docker containerization, and a complete **Jenkins CI/CD pipeline**.

---

## 📁 Project Structure

java-maven-project/
├── src/
│ ├── main/
│ │ └── java/
│ │ └── com/example/demo/
│ │ ├── DemoApplication.java
│ │ └── HelloController.java
│ └── test/
│ └── java/
│ └── com/example/demo/
│ └── DemoApplicationTests.java
├── Dockerfile
├── Jenkinsfile
├── pom.xml
├── .gitignore
└── README.md

---

## 🚀 Features

- **Spring Boot 3.3.4** (Java 17 compatible)
- REST API endpoint: `GET /hello` → returns “Hello, World!”
- **Dockerized** for easy deployment
- **Jenkins pipeline** for CI/CD automation
- Unit testing using **JUnit 5**

---

## 🧰 Prerequisites

- Java 17 or higher
- Maven 3+
- Docker (optional, for containerization)
- Jenkins (for CI/CD)

---

## ⚙️ Build and Run

### Run locally
```bash
mvn spring-boot:run
```
Access the app at:
👉 http://localhost:8080/hello

### Build a JAR
```bash
mvn clean package
java -jar target/demo-0.0.1-SNAPSHOT.jar
```

### 🐳 Docker Setup
#### Build Docker image
```bash
docker build -t java-maven-app .
```
#### Run container
```bash
docker run -p 8080:8080 java-maven-app
```

### 🧪 Jenkins CI/CD
The included Jenkinsfile automates:

- Code checkout
- Maven build
- Unit tests
- Docker image creation
- Deployment

Example Jenkins pipeline stages:

```groovy
pipeline {
    agent none  // Distributed pipeline
    stages {
        stage('Checkout') {
            agent any
            steps {
                git branch: 'main',
                    url: 'https://github.com/tijilparakh04/DevOps_Lab_5.git'
            }
        }
        stage('Build') {
            agent { label 'maven-slave1' }  // Compile on slave1
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Test') {
            agent { label 'maven-slave2' }  // Test on slave2
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            agent any
            steps {
                sh 'mvn package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            agent any
            steps {
                sh 'docker build -t java-maven-app .'
            }
        }
        stage('Deploy') {
            agent any
            steps {
                echo 'Deploying application...'
            }
        }
    }
}
```

### Author
Tijil Parakh
GitHub: @tijilparakh04
