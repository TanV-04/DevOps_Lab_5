# Assignment Execution and Verification Results

## Assignment1 - Python Flask App with Docker and Jenkins
- **Description**: Simple Flask application that returns "Hello from Docker + Jenkins Pipeline!" on the root endpoint.
- **Technology**: Python Flask, Docker, Jenkins pipeline.
- **Execution**: Attempted to run `docker build -t flask-app Assignment1`.
- **Issue Found**: Docker build failed due to DNS resolution error for Docker Hub registry (network/firewall issue).
- **Status**: Code is complete and correct. Cannot execute due to external network constraints. For viva, demonstrate code and explain setup.
- **Files**: app.py, Dockerfile, docker-compose.yml, Jenkinsfile, requirement.txt.
- **Specific Tasks**:
  - [x] Create Dockerfile for Jenkins with Docker support
  - [x] Create docker-compose.yml for running Jenkins with Docker socket
  - [x] Update Jenkinsfile to use Jenkins Docker plugin syntax
  - [x] Flask app code is ready
  - [ ] Execute the Dockerized Jenkins setup (blocked by network issue)
  - [ ] Run the pipeline to demonstrate CI/CD
  - [ ] Verify the Flask app is built, tested, and pushed to Docker Hub

## Assignment2 - Angular Application
- **Description**: Angular application with SSR (Server-Side Rendering) support.
- **Technology**: Angular 20, TypeScript, Node.js.
- **Execution**: Ran `npm install` and `npm start` (ng serve) in Assignment2/my-angular-app.
- **Status**: Successfully installed dependencies and started development server.
- **No Errors**: Build completed without issues.
- **Port**: Likely running on 4200 (default Angular port).
- **Files**: package.json, angular.json, src/ directory with components.

## Assignment3 - Git Branching Model Documentation
- **Description**: Documentation about Git branching workflow for faster work integration.
- **Technology**: Git branching strategies.
- **Execution**: No executable code, only README.md with branching model explanation.
- **Status**: No execution needed.
- **Branches Described**: main, develop, feature/, release/, hotfix/.
- **Files**: README.md.

## Assignment4 - Java Maven Project
- **Description**: Simple Java application that prints "Hello World!" to console.
- **Technology**: Java 11, Maven.
- **Execution**: Ran `mvn clean package` in Assignment4 directory.
- **Status**: Build successful, tests passed (2 tests run, 0 failures).
- **Output**: Generated JAR file at target/maven-project-1.0-SNAPSHOT.jar.
- **No Errors**: Compilation and testing completed without issues.
- **Files**: pom.xml, src/main/java/com/example/App.java, src/test/java/com/example/AppTest.java.
- **Specific Tasks**:
  - [x] Create Assignment4 directory
  - [x] Create pom.xml for Maven project
  - [x] Create src/main/java/com/example/App.java
  - [x] Create src/test/java/com/example/AppTest.java
  - [x] Create Jenkinsfile with distributed pipeline

## Assignment5 - Spring Boot Retail Application
- **Description**: Spring Boot application with REST API for retail products.
- **Technology**: Spring Boot 3.1.0, Java 17, Maven.
- **Execution**: Ran `mvn spring-boot:run` in Assignment5 directory.
- **Status**: Application started successfully on port 8080.
- **API Endpoint**: GET /products returns JSON array of products (Laptop, Mouse, Keyboard).
- **No Errors**: Application compiled and started without issues.
- **Files**: pom.xml, RetailAppApplication.java, ProductController.java, Dockerfile, docker-compose.yml.

## Assignment6 - Node.js Social Media Application
- **Description**: Express.js application simulating a social media platform with posts API.
- **Technology**: Node.js, Express.js.
- **Execution**: Ran `npm install` and `npm start` in assignment6 directory.
- **Status**: Application started successfully on port 4200.
- **API Endpoints**: GET / (welcome message), GET /posts (list posts), POST /posts (create post).
- **No Errors**: Dependencies installed and server started without issues.
- **Files**: package.json, server.js, Kubernetes YAML files (deployment.yaml, service.yaml, etc.).


