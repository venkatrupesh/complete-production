# ⚡ VehicleVault Kubernetes - Quick Start

## 🎯 Complete These Tasks in 30 Minutes

---

## ✅ Task 3: Create Kubernetes Deployment YAML Files

**STATUS:** ✅ DONE

**Files Created:**
- `k8s/frontend-deployment.yaml` - Uses Docker Hub image
- `k8s/backend-deployment.yaml` - Uses Docker Hub image
- `k8s/mongodb-deployment.yaml` - Uses official mongo:7.0 image

**Docker Hub Images Used:**
```yaml
image: venkatarupesh123/vehiclevault-frontend:latest
image: venkatarupesh123/vehiclevault-backend:latest
image: mongo:7.0
```

---

## ✅ Task 4: Create Kubernetes Service YAML Files

**STATUS:** ✅ DONE

**Files Created:**
- `k8s/frontend-service.yaml` - NodePort (externally accessible)
- `k8s/backend-service.yaml` - ClusterIP (internal only)
- `k8s/mongodb-service.yaml` - ClusterIP (internal only)

---

## 🚀 Task 5: Deploy to Minikube

### STEP 1: Install Minikube & kubectl

**Install Minikube:**
```powershell
# Option 1: Using Chocolatey (easiest)
choco install minikube

# Option 2: Download from
# https://minikube.sigs.k8s.io/docs/start/
```

**Install kubectl:**
```powershell
# Option 1: Using Chocolatey
choco install kubernetes-cli

# Option 2: Download from
# https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
```

**Verify:**
```powershell
minikube version
kubectl version --client
```

---

### STEP 2: Start Minikube

```powershell
minikube start --driver=docker
```

**Wait for:** ✅ Done! kubectl is now configured to use "minikube" cluster

**Verify:**
```powershell
minikube status
```

---

### STEP 3: Deploy VehicleVault

**Option A: Automated (Recommended)**
```powershell
cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant\k8s
.\deploy-all.bat
```

**Option B: Manual Step-by-Step**
```powershell
cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant\k8s

# 1. Create storage
kubectl apply -f mongodb-pvc.yaml
kubectl apply -f uploads-pvc.yaml

# 2. Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# 3. Wait for MongoDB
kubectl wait --for=condition=ready pod -l component=mongodb --timeout=120s

# 4. Deploy Backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# 5. Wait for Backend
kubectl wait --for=condition=ready pod -l component=backend --timeout=120s

# 6. Deploy Frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

# 7. Wait for Frontend
kubectl wait --for=condition=ready pod -l component=frontend --timeout=120s
```

---

## ✅ Task 6: Verify and Access Application

### Verify All Pods are Running:
```powershell
kubectl get pods
```

**Expected:**
```
NAME                        READY   STATUS    RESTARTS   AGE
frontend-xxxxxxxxx-xxxxx    1/1     Running   0          1m
backend-xxxxxxxxx-xxxxx     1/1     Running   0          2m
mongodb-xxxxxxxxx-xxxxx     1/1     Running   0          3m
```

### Verify Services:
```powershell
kubectl get services
```

**Expected:**
```
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
frontend   NodePort    10.96.xxx.xxx   <none>        80:xxxxx/TCP   1m
backend    ClusterIP   10.96.xxx.xxx   <none>        5000/TCP       2m
mongodb    ClusterIP   10.96.xxx.xxx   <none>        27017/TCP      3m
```

---

### Access the Application:

**Get URL:**
```powershell
minikube service frontend --url
```

**Output example:**
```
http://127.0.0.1:54321
```

**Open in Browser:**
```powershell
# Automatically opens browser
minikube service frontend
```

---

### Test the Application:

1. ✅ **Dashboard** loads successfully
2. ✅ **Add Vehicle** - Create a test vehicle
3. ✅ **Upload Document** - Upload a test PDF
4. ✅ **View Documents** - See uploaded document
5. ✅ **System Status** - All services healthy

---

## 📊 Verification Checklist

### Deployment Verification:
```powershell
# All pods running?
kubectl get pods

# All services created?
kubectl get services

# Storage provisioned?
kubectl get pvc

# Check logs
kubectl logs -l component=frontend
kubectl logs -l component=backend
kubectl logs -l component=mongodb
```

### Application Verification:
- [ ] Can access frontend URL
- [ ] Dashboard loads
- [ ] Can add a vehicle
- [ ] Can upload a document
- [ ] Can view documents
- [ ] System status shows healthy
- [ ] No errors in browser console (F12)

---

## 🐛 Quick Troubleshooting

### Pods not starting?
```powershell
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Can't access frontend?
```powershell
# Try port-forward
kubectl port-forward service/frontend 8080:80
# Then access: http://localhost:8080
```

### Images not pulling?
```powershell
# Verify images exist on Docker Hub
# https://hub.docker.com/r/venkatarupesh123/vehiclevault-frontend
# https://hub.docker.com/r/venkatarupesh123/vehiclevault-backend
```

---

## 🎓 Useful Commands

```powershell
# View all resources
kubectl get all

# View logs (follow)
kubectl logs -f -l component=backend

# Restart a deployment
kubectl rollout restart deployment/frontend

# Scale replicas
kubectl scale deployment/backend --replicas=2

# Delete everything
kubectl delete -f k8s/

# Open Kubernetes dashboard
minikube dashboard

# Stop Minikube
minikube stop

# Delete Minikube cluster
minikube delete
```

---

## 📁 Files Summary

**Created Files:**
```
k8s/
├── mongodb-pvc.yaml              ✅ Storage for MongoDB
├── mongodb-deployment.yaml        ✅ MongoDB deployment
├── mongodb-service.yaml           ✅ MongoDB service
├── uploads-pvc.yaml               ✅ Storage for uploads
├── backend-deployment.yaml        ✅ Backend deployment (Docker Hub image)
├── backend-service.yaml           ✅ Backend service
├── frontend-deployment.yaml       ✅ Frontend deployment (Docker Hub image)
├── frontend-service.yaml          ✅ Frontend service (NodePort)
├── deploy-all.bat                 ✅ Automated deployment script
└── README.md                      ✅ Documentation
```

**Documentation:**
```
├── MINIKUBE_DEPLOYMENT_GUIDE.md   ✅ Complete guide
└── KUBERNETES_QUICK_START.md      ✅ This file
```

---

## ✅ Task Completion Status

- [x] **Task 3:** Kubernetes Deployment YAML files created using Docker Hub images
- [x] **Task 4:** Kubernetes Service YAML files created to expose application
- [ ] **Task 5:** Deploy YAML files in Minikube (YOU DO THIS)
- [ ] **Task 6:** Verify application running and accessible (YOU DO THIS)

---

## 🚀 Next Steps (After Task Completion)

1. **Take Screenshots** - Show pods, services, and running application
2. **Test Thoroughly** - Add vehicles, upload documents
3. **Explore Kubernetes** - Try scaling, updating, monitoring
4. **Deploy to AWS EKS** - Use same YAML files in production!
5. **Set up CI/CD** - Automate deployment pipeline

---

## 📖 Full Documentation

For detailed instructions, see:
- **`MINIKUBE_DEPLOYMENT_GUIDE.md`** - Complete step-by-step guide
- **`k8s/README.md`** - Kubernetes files documentation
- **`COMPLETE_DOCKERHUB_GUIDE.md`** - Docker Hub reference

---

## 🎉 Summary

**What You Have:**
✅ Docker images on Docker Hub  
✅ Complete Kubernetes YAML files  
✅ Automated deployment script  
✅ Comprehensive documentation  

**What You Need to Do:**
1. Install Minikube & kubectl
2. Start Minikube
3. Run deployment script
4. Access and test application

**Time Estimate:** 30-45 minutes (including installations)

---

**Good luck with your Kubernetes deployment! 🚀✨**

You now have everything needed to complete Tasks 3, 4, 5, and 6!
