@echo off
REM VehicleVault - Complete Docker Hub Push Script
REM This script builds, tags, and pushes both frontend and backend to Docker Hub

echo ========================================
echo   VehicleVault - Docker Hub Push
echo ========================================
echo.

REM Configuration - Change if needed
set DOCKER_USERNAME=venkatarupesh123
set VERSION=v1.0.0

echo 📋 Configuration:
echo    Username: %DOCKER_USERNAME%
echo    Version:  %VERSION%
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker is not running!
    echo    Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo.

REM Step 1: Build images
echo ========================================
echo STEP 1: Building Docker Images
echo ========================================
echo.
echo 🔨 Building frontend and backend...
docker compose build
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed!
    pause
    exit /b 1
)
echo ✅ Build completed
echo.

REM Step 2: Tag images
echo ========================================
echo STEP 2: Tagging Images
echo ========================================
echo.

echo 🏷️  Tagging frontend...
docker tag vehiclevault-frontend %DOCKER_USERNAME%/vehiclevault-frontend:latest
docker tag vehiclevault-frontend %DOCKER_USERNAME%/vehiclevault-frontend:%VERSION%

echo 🏷️  Tagging backend...
docker tag vehiclevault-backend %DOCKER_USERNAME%/vehiclevault-backend:latest
docker tag vehiclevault-backend %DOCKER_USERNAME%/vehiclevault-backend:%VERSION%

echo ✅ Tagging completed
echo.

REM Step 3: Push frontend
echo ========================================
echo STEP 3: Pushing Frontend to Docker Hub
echo ========================================
echo.

echo 🚀 Pushing frontend:latest...
docker push %DOCKER_USERNAME%/vehiclevault-frontend:latest
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Frontend:latest push failed
    echo    Continuing anyway...
)

echo 🚀 Pushing frontend:%VERSION%...
docker push %DOCKER_USERNAME%/vehiclevault-frontend:%VERSION%
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Frontend:%VERSION% push failed
)

echo.

REM Step 4: Push backend
echo ========================================
echo STEP 4: Pushing Backend to Docker Hub
echo ========================================
echo.

echo 🚀 Pushing backend:latest...
docker push %DOCKER_USERNAME%/vehiclevault-backend:latest
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Backend:latest push failed
    echo    Continuing anyway...
)

echo 🚀 Pushing backend:%VERSION%...
docker push %DOCKER_USERNAME%/vehiclevault-backend:%VERSION%
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Backend:%VERSION% push failed
)

echo.

REM Step 5: Verify
echo ========================================
echo STEP 5: Verification
echo ========================================
echo.

echo 📦 Your images on Docker Hub:
echo.
echo    Frontend:
echo    https://hub.docker.com/r/%DOCKER_USERNAME%/vehiclevault-frontend
echo.
echo    Backend:
echo    https://hub.docker.com/r/%DOCKER_USERNAME%/vehiclevault-backend
echo.

echo ========================================
echo ✅ DONE!
echo ========================================
echo.
echo To pull these images anywhere:
echo    docker pull %DOCKER_USERNAME%/vehiclevault-frontend:latest
echo    docker pull %DOCKER_USERNAME%/vehiclevault-backend:latest
echo.

pause
