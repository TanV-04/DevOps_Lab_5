@echo off
echo ================================
echo    TRIVY SECURITY SCANNING
echo ================================

cd C:\Users\Atharva\Downloads\trivy_0.66.0_windows-64bit

if not exist "reports" mkdir reports

echo [1/5] Basic vulnerability scan...
trivy image simple-app:latest

echo.
echo [2/5] High/Critical vulnerabilities only...
trivy image --severity HIGH,CRITICAL simple-app:latest

echo.
echo [3/5] Generating JSON report...
trivy image --format json --output reports\vulnerability-report.json simple-app:latest

echo.
echo [4/5] Scanning for secrets...
trivy image --scanners secret --format table simple-app:latest

echo.
echo [5/5] Configuration issues scan...
trivy image --scanners config --format table simple-app:latest

echo.
echo ================================
echo   SCAN REPORTS GENERATED
echo ================================
echo Reports saved in: reports\
dir reports
pause
