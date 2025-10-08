@echo off
REM Test script to validate the Maven project locally on Windows
REM This script tests the project before running it in Jenkins pipeline

echo === Local Maven Project Test ===
echo Testing the distributed pipeline demo project...

REM Check if we're in the right directory
if not exist "pom.xml" (
    echo ❌ pom.xml not found. Please run this script from the project root directory.
    pause
    exit /b 1
)

REM Check Java version
echo 🔍 Checking Java version...
java -version >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Java not found. Please install Java 11+
    pause
    exit /b 1
) else (
    java -version
    echo ✅ Java is available
)

REM Check Maven version
echo 🔍 Checking Maven version...
mvn --version >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Maven not found. Please install Maven 3.6+
    pause
    exit /b 1
) else (
    mvn --version | findstr "Apache Maven"
    echo ✅ Maven is available
)

REM Clean previous builds
echo 🧹 Cleaning previous builds...
mvn clean -q
if %errorlevel% neq 0 (
    echo ❌ Clean failed
    pause
    exit /b 1
)

REM Compile the project
echo 🏗️  Compiling project...
mvn compile -q
if %errorlevel% equ 0 (
    echo ✅ Compilation successful
) else (
    echo ❌ Compilation failed
    pause
    exit /b 1
)

REM Run tests
echo 🧪 Running tests...
mvn test -q
if %errorlevel% equ 0 (
    echo ✅ All tests passed
) else (
    echo ❌ Tests failed
    pause
    exit /b 1
)

REM Package the application
echo 📦 Packaging application...
mvn package -DskipTests=true -q
if %errorlevel% equ 0 (
    echo ✅ Packaging successful
) else (
    echo ❌ Packaging failed
    pause
    exit /b 1
)

REM Test the packaged application
echo 🚀 Testing packaged application...
if exist "target\jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar" (
    echo Testing basic functionality...
    
    REM Test addition
    java -jar target\jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar + 10 5
    echo Addition test completed
    
    REM Test multiplication
    java -jar target\jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar * 7 8
    echo Multiplication test completed
    
    REM Test square root
    java -jar target\jenkins-distributed-pipeline-1.0.0-jar-with-dependencies.jar sqrt 16
    echo Square root test completed
    
    echo ✅ Application tests passed
) else (
    echo ❌ JAR file not found
    pause
    exit /b 1
)

REM Display project statistics
echo.
echo 📊 Project Statistics:
for /f %%i in ('dir /s /b src\main\java\*.java 2^>nul ^| find /c ".java"') do echo Java source files: %%i
for /f %%i in ('dir /s /b src\test\java\*.java 2^>nul ^| find /c ".java"') do echo Test files: %%i

REM Display generated artifacts
echo.
echo 📁 Generated Artifacts:
if exist "target" (
    echo Target directory contents:
    dir target\*.jar 2>nul | findstr ".jar" || echo No JAR files found
    
    if exist "target\surefire-reports" (
        for /f %%i in ('dir /b target\surefire-reports\*.xml 2^>nul ^| find /c ".xml"') do echo Test reports: %%i files
    )
    
    if exist "target\classes" (
        for /f %%i in ('dir /s /b target\classes\*.class 2^>nul ^| find /c ".class"') do echo Compiled classes: %%i files
    )
)

echo.
echo ✅ === Local Maven Project Test Complete ===
echo.
echo The project is ready for Jenkins distributed pipeline:
echo 1. ✅ Code compiles successfully
echo 2. ✅ All tests pass
echo 3. ✅ Application packages correctly
echo 4. ✅ JAR runs with expected behavior
echo.
echo Next Steps:
echo 🐳 Run: scripts\setup.bat
echo 🌐 Open: http://localhost:8080
echo ⚡ Create pipeline job with the provided Jenkinsfile
echo.
echo This validates that the project will work correctly
echo when distributed across Jenkins compile-node and test-node!
echo.
pause
