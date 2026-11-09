@echo off
REM VehicleVault - Deploy to Minikube

echo ========================================
echo  VehicleVault - Minikube Deployment
echo ========================================
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ kubectl is not installed!
    echo    Please install kubectl first.
    echo    See: MINIKUBE_DEPLOYMENT_GUIDE.md
    pause
    exit /b 1
)

REM Check if minikube is running
minikube status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Minikube is not running!
    echo    Start Minikube first: minikube start
    pause
    exit /b 1
)

echo ✅ kubectl and Minikube are ready
echo.

REM Step 1: Create PVCs
echo ========================================
echo STEP 1: Creating Persistent Volume Claims
echo ========================================
echo.

kubectl apply -f mongodb-pvc.yaml
kubectl apply -f uploads-pvc.yaml

echo ✅ PVCs created
echo.
timeout /t 3 /nobreak >nul

REM Step 2: Deploy MongoDB
echo ========================================
echo STEP 2: Deploying MongoDB
echo ========================================
echo.

kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

echo ✅ MongoDB deployed
echo    Waiting for MongoDB to be ready...
echo.

kubectl wait --for=condition=ready pod -l component=mongodb --timeout=120s

echo.

REM Step 3: Deploy Backend
echo ========================================
echo STEP 3: Deploying Backend
echo ========================================
echo.

kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

echo ✅ Backend deployed
echo    Waiting for Backend to be ready...
echo.

kubectl wait --for=condition=ready pod -l component=backend --timeout=120s

echo.

REM Step 4: Deploy Frontend
echo ========================================
echo STEP 4: Deploying Frontend
echo ========================================
echo.

kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

echo ✅ Frontend deployed
echo    Waiting for Frontend to be ready...
echo.

kubectl wait --for=condition=ready pod -l component=frontend --timeout=120s

echo.

REM Step 5: Show status
echo ========================================
echo STEP 5: Deployment Status
echo ========================================
echo.

echo 📦 Pods:
kubectl get pods
echo.

echo 🌐 Services:
kubectl get services
echo.

echo 💾 PVCs:
kubectl get pvc
echo.

REM Step 6: Get access URL
echo ========================================
echo ✅ DEPLOYMENT COMPLETE!
echo ========================================
echo.

echo 🚀 Access your application:
echo.
minikube service frontend --url
echo.

echo Opening application in browser...
timeout /t 3 /nobreak >nul
minikube service frontend

pause
