@echo off
REM Jenkins Distributed Pipeline Cleanup Script for Windows
REM This script stops and cleans up the Jenkins infrastructure

echo === Jenkins Distributed Pipeline Cleanup ===

cd /d "%~dp0..\docker"

echo 🛑 Stopping Jenkins services...
docker-compose down

echo 🗑️  Removing containers...
docker-compose rm -f

echo.
echo Cleanup options:
echo 1. Keep data volumes (recommended for development)
echo 2. Remove data volumes (complete cleanup - WARNING: all data will be lost!)
echo 3. Remove everything including images
echo.
set /p choice="Choose option (1-3): "

if "%choice%"=="1" (
    echo ✅ Services stopped, data volumes preserved
    echo To restart: run setup.bat again
) else if "%choice%"=="2" (
    echo 🗑️  Removing data volumes...
    docker-compose down -v
    docker volume prune -f
    echo ⚠️  All Jenkins data has been removed!
    echo To restart: run setup.bat again (will be fresh installation)
) else if "%choice%"=="3" (
    echo 🗑️  Removing everything...
    docker-compose down -v --rmi all
    docker volume prune -f
    docker image prune -a -f
    echo ⚠️  Everything removed including Docker images!
    echo To restart: run setup.bat again (will rebuild images)
) else (
    echo Invalid choice. Only stopped services.
)

echo.
echo Jenkins infrastructure cleanup completed.
pause
