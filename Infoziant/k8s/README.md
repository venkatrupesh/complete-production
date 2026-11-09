# VehicleVault - Kubernetes Deployment Files

## 📁 Files Overview

This directory contains all Kubernetes manifest files for deploying VehicleVault to Minikube or any Kubernetes cluster.

---

## 📋 File Descriptions

### Persistent Volume Claims (Storage)
- **`mongodb-pvc.yaml`** - 1Gi storage for MongoDB data
- **`uploads-pvc.yaml`** - 2Gi storage for uploaded documents

### MongoDB (Database)
- **`mongodb-deployment.yaml`** - MongoDB 7.0 deployment
- **`mongodb-service.yaml`** - ClusterIP service (internal only)

### Backend (API Server)
- **`backend-deployment.yaml`** - Node.js backend using Docker Hub image
- **`backend-service.yaml`** - ClusterIP service (internal only)

### Frontend (Web App)
- **`frontend-deployment.yaml`** - React frontend using Docker Hub image
- **`frontend-service.yaml`** - NodePort service (externally accessible)

### Helper Scripts
- **`deploy-all.bat`** - Automated deployment script (Windows)
- **`README.md`** - This file

---

## 🚀 Quick Start

### Prerequisites:
1. Install Minikube
2. Install kubectl
3. Start Minikube: `minikube start`

### Deploy Everything:
```powershell
cd k8s
.\deploy-all.bat
```

### Or Deploy Manually:
```powershell
# 1. Create storage
kubectl apply -f mongodb-pvc.yaml
kubectl apply -f uploads-pvc.yaml

# 2. Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# 3. Deploy Backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# 4. Deploy Frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

# 5. Access application
minikube service frontend
```

---

## 📖 Documentation

See **`MINIKUBE_DEPLOYMENT_GUIDE.md`** in parent directory for:
- Complete installation instructions
- Step-by-step deployment guide
- Troubleshooting tips
- Useful kubectl commands
- Architecture overview

---

## 🔗 Docker Hub Images

These deployments use images from Docker Hub:
- **Frontend:** `venkatarupesh123/vehiclevault-frontend:latest`
- **Backend:** `venkatarupesh123/vehiclevault-backend:latest`
- **MongoDB:** `mongo:7.0` (official)

---

## ✅ Verify Deployment

```powershell
# Check all pods are running
kubectl get pods

# Check services
kubectl get services

# Get frontend URL
minikube service frontend --url
```

---

## 🗑️ Clean Up

```powershell
# Delete everything
kubectl delete -f .

# Or delete all resources
kubectl delete all --all
kubectl delete pvc --all
```

---

## 📊 Resource Allocation

| Component | CPU Request | CPU Limit | Memory Request | Memory Limit |
|-----------|-------------|-----------|----------------|--------------|
| Frontend  | 100m        | 200m      | 128Mi          | 256Mi        |
| Backend   | 250m        | 500m      | 256Mi          | 512Mi        |
| MongoDB   | 250m        | 500m      | 256Mi          | 512Mi        |

**Total:** ~600m CPU, ~640Mi Memory (minimum)

---

## 🎯 Task Completion

✅ **Task 3:** Created Kubernetes Deployment YAML files using Docker Hub images  
✅ **Task 4:** Created Kubernetes Service YAML files to expose application  
✅ **Task 5 & 6:** Ready to deploy and verify in Minikube

---

## 🔄 Update Application

When you update code:

1. Build and push new images:
   ```powershell
   cd ..
   .\PUSH_TO_DOCKERHUB.bat
   ```

2. Restart deployments:
   ```powershell
   kubectl rollout restart deployment/frontend
   kubectl rollout restart deployment/backend
   ```

---

## 🌐 Architecture

```
Browser
  ↓
Frontend (NodePort :80)
  ↓
Backend (ClusterIP :5000)
  ↓
MongoDB (ClusterIP :27017)
  ↓
Persistent Storage (PVCs)
```

---

## 📞 Support

For issues, see:
- **MINIKUBE_DEPLOYMENT_GUIDE.md** - Troubleshooting section
- **COMPLETE_DOCKERHUB_GUIDE.md** - Docker Hub help

---

**Happy Deploying! 🚀**
