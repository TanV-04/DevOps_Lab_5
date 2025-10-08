@echo off
REM Jenkins Distributed Pipeline Setup Script for Windows
REM This script sets up the entire Jenkins infrastructure with Docker

echo === Jenkins Distributed Pipeline Setup ===
echo Setting up Jenkins master with distributed slave nodes...

REM Check prerequisites
echo Checking prerequisites...

where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

where docker-compose >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

REM Check if ports are available
netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Port 8080 is already in use. Please stop the service using it or change the port.
    set /p continue="Continue anyway? (y/N): "
    if /i not "%continue%"=="y" exit /b 1
)

netstat -an | findstr ":50000" >nul  
if %errorlevel% equ 0 (
    echo ⚠️  Port 50000 is already in use. Please stop the service using it or change the port.
    set /p continue="Continue anyway? (y/N): "
    if /i not "%continue%"=="y" exit /b 1
)

echo ✅ Prerequisites check passed

REM Navigate to docker directory
cd /d "%~dp0..\docker"

echo Starting Jenkins infrastructure...

REM Pull latest images
echo 📥 Pulling Docker images...
docker-compose pull

REM Build custom slave images
echo 🏗️  Building Jenkins slave images...
docker-compose build --no-cache

REM Start services
echo 🚀 Starting Jenkins services...
docker-compose up -d

echo ⏳ Waiting for services to start...
timeout /t 30 /nobreak >nul

REM Check service health
echo 🔍 Checking service health...
docker-compose ps | findstr jenkins-master | findstr Up >nul
if %errorlevel% equ 0 (
    echo ✅ Jenkins Master: Running
) else (
    echo ❌ Jenkins Master: Failed to start
    docker-compose logs jenkins-master
    pause
    exit /b 1
)

REM Wait for Jenkins to be fully ready
echo ⏳ Waiting for Jenkins to initialize (this may take a few minutes)...
set counter=0

:wait_loop
curl -s http://localhost:8080/login >nul 2>nul
if %errorlevel% equ 0 goto jenkins_ready

timeout /t 10 /nobreak >nul
set /a counter+=10
if %counter% geq 300 (
    echo ❌ Timeout waiting for Jenkins to start
    echo Check the logs with: docker-compose logs jenkins-master
    pause
    exit /b 1
)
echo Still waiting... (%counter%s/300s)
goto wait_loop

:jenkins_ready
echo ✅ Jenkins Master is ready!

REM Check slave connections
echo 🔍 Checking slave node connections...
timeout /t 20 /nobreak >nul

docker-compose ps | findstr jenkins-slave-compile | findstr Up >nul
if %errorlevel% equ 0 (
    echo ✅ Compile Node: Running
) else (
    echo ⚠️  Compile Node: Not running properly
    echo Check logs with: docker-compose logs jenkins-slave-compile
)

docker-compose ps | findstr jenkins-slave-test | findstr Up >nul
if %errorlevel% equ 0 (
    echo ✅ Test Node: Running
) else (
    echo ⚠️  Test Node: Not running properly
    echo Check logs with: docker-compose logs jenkins-slave-test
)

REM Display connection information
echo.
echo 🎉 === Setup Complete! ===
echo.
echo Access Information:
echo 📱 Jenkins URL: http://localhost:8080
echo 👤 Username: admin
echo 🔑 Password: admin123
echo.
echo Node Configuration:
echo 🖥️  Master Node: jenkins-master (orchestration)
echo ⚙️  Compile Node: compile-node (compilation ^& packaging)
echo 🧪 Test Node: test-node (testing ^& quality analysis)
echo.
echo Next Steps:
echo 1. Open http://localhost:8080 in your browser
echo 2. Login with admin/admin123
echo 3. Create a new Pipeline job
echo 4. Use the Jenkinsfile from this project
echo 5. Run the distributed pipeline!
echo.
echo Useful Commands:
echo 📊 Check status: docker-compose ps
echo 📋 View logs: docker-compose logs [service-name]
echo 🛑 Stop services: docker-compose down
echo 🔄 Restart services: docker-compose restart
echo.
echo For detailed setup instructions, see: docs\SETUP_GUIDE.md
echo.

REM Ask about creating sample job
set /p create_job="Would you like to create a sample pipeline job automatically? (y/N): "
if /i "%create_job%"=="y" (
    echo 🏗️  Creating sample pipeline job...
    
    REM Create temporary pipeline script
    echo pipeline { > %temp%\pipeline.groovy
    echo     agent none >> %temp%\pipeline.groovy
    echo     stages { >> %temp%\pipeline.groovy
    echo         stage('Demo Info') { >> %temp%\pipeline.groovy
    echo             agent any >> %temp%\pipeline.groovy
    echo             steps { >> %temp%\pipeline.groovy
    echo                 echo "=== Jenkins Distributed Pipeline Demo ===" >> %temp%\pipeline.groovy
    echo                 echo "- Compilation will run on: compile-node" >> %temp%\pipeline.groovy
    echo                 echo "- Testing will run on: test-node" >> %temp%\pipeline.groovy
    echo             } >> %temp%\pipeline.groovy
    echo         } >> %temp%\pipeline.groovy
    echo         stage('Compile') { >> %temp%\pipeline.groovy
    echo             agent { label 'compile-node' } >> %temp%\pipeline.groovy
    echo             steps { >> %temp%\pipeline.groovy
    echo                 echo "🏗️ Compiling on compile-node: ${NODE_NAME}" >> %temp%\pipeline.groovy
    echo                 sh 'java -version ^|^| echo Java available' >> %temp%\pipeline.groovy
    echo             } >> %temp%\pipeline.groovy
    echo         } >> %temp%\pipeline.groovy
    echo         stage('Test') { >> %temp%\pipeline.groovy
    echo             agent { label 'test-node' } >> %temp%\pipeline.groovy
    echo             steps { >> %temp%\pipeline.groovy
    echo                 echo "🧪 Testing on test-node: ${NODE_NAME}" >> %temp%\pipeline.groovy
    echo                 sh 'java -version ^|^| echo Java available' >> %temp%\pipeline.groovy
    echo             } >> %temp%\pipeline.groovy
    echo         } >> %temp%\pipeline.groovy
    echo     } >> %temp%\pipeline.groovy
    echo } >> %temp%\pipeline.groovy
    
    echo ✅ Sample pipeline script created
    echo You can copy the content from Jenkinsfile to create a new pipeline job manually.
    del /q %temp%\pipeline.groovy 2>nul
)

echo.
echo 🚀 Jenkins Distributed Pipeline is ready for use!
echo Press any key to open Jenkins in your browser...
pause >nul
start http://localhost:8080
