# 🚀 VehicleVault - Minikube Deployment Guide

## Complete Step-by-Step Guide to Deploy on Minikube

---

## **Prerequisites**

Before starting, you need to install:

1. ✅ **Minikube** - Local Kubernetes cluster
2. ✅ **kubectl** - Kubernetes command-line tool
3. ✅ **Docker Desktop** - Already installed ✓

---

## **STEP 1: Install Minikube**

### For Windows:

**Option A: Using Chocolatey (Easiest)**
```powershell
# Install Chocolatey first (if not installed)
# Visit: https://chocolatey.org/install

# Then install Minikube
choco install minikube
```

**Option B: Manual Installation**
1. Download from: https://minikube.sigs.k8s.io/docs/start/
2. Download the Windows installer (.exe)
3. Run the installer
4. Restart PowerShell

**Verify Installation:**
```powershell
minikube version
```

---

## **STEP 2: Install kubectl**

**Option A: Using Chocolatey**
```powershell
choco install kubernetes-cli
```

**Option B: Manual Installation**
1. Download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
2. Add to PATH
3. Restart PowerShell

**Verify Installation:**
```powershell
kubectl version --client
```

---

## **STEP 3: Start Minikube**

```powershell
# Start Minikube with Docker driver
minikube start --driver=docker

# This will:
# - Download Kubernetes components
# - Create a local Kubernetes cluster
# - Takes 3-5 minutes first time
```

**Wait for:**
```
✅ Done! kubectl is now configured to use "minikube" cluster
```

**Verify Minikube is running:**
```powershell
minikube status
```

Expected output:
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

---

## **STEP 4: Navigate to k8s Directory**

```powershell
cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant\k8s
```

---

## **STEP 5: Deploy to Minikube**

### Deploy in Order:

#### 1. Create Persistent Volume Claims (Storage)
```powershell
kubectl apply -f mongodb-pvc.yaml
kubectl apply -f uploads-pvc.yaml
```

**Verify:**
```powershell
kubectl get pvc
```

Expected:
```
NAME          STATUS   VOLUME    CAPACITY   ACCESS MODES
mongodb-pvc   Bound    pvc-xxx   1Gi        RWO
uploads-pvc   Bound    pvc-yyy   2Gi        RWO
```

---

#### 2. Deploy MongoDB
```powershell
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml
```

**Verify:**
```powershell
kubectl get pods
```

Wait until:
```
NAME                      READY   STATUS    RESTARTS   AGE
mongodb-xxxxxxxxx-xxxxx   1/1     Running   0          30s
```

**Check MongoDB logs:**
```powershell
kubectl logs -l component=mongodb
```

---

#### 3. Deploy Backend
```powershell
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

**Verify:**
```powershell
kubectl get pods
```

Wait until:
```
NAME                       READY   STATUS    RESTARTS   AGE
backend-xxxxxxxxx-xxxxx    1/1     Running   0          30s
mongodb-xxxxxxxxx-xxxxx    1/1     Running   0          2m
```

**Check Backend logs:**
```powershell
kubectl logs -l component=backend
```

Look for:
```
[server] MongoDB connected — db: vehiclevault
[server] VehicleVault API running on port 5000 (production)
```

---

#### 4. Deploy Frontend
```powershell
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

**Verify:**
```powershell
kubectl get pods
```

Wait until ALL pods are Running:
```
NAME                        READY   STATUS    RESTARTS   AGE
frontend-xxxxxxxxx-xxxxx    1/1     Running   0          30s
backend-xxxxxxxxx-xxxxx     1/1     Running   0          2m
mongodb-xxxxxxxxx-xxxxx     1/1     Running   0          4m
```

---

## **STEP 6: Verify Deployment**

### Check All Resources:
```powershell
# All pods
kubectl get pods

# All services
kubectl get services

# All deployments
kubectl get deployments

# All PVCs
kubectl get pvc

# Everything at once
kubectl get all
```

---

## **STEP 7: Access the Application**

### Get the Service URL:
```powershell
minikube service frontend --url
```

This will show something like:
```
http://127.0.0.1:xxxxx
```

### Open in Browser:

**Option A: Automatic (opens browser)**
```powershell
minikube service frontend
```

**Option B: Manual**
```powershell
# Get URL
minikube service frontend --url

# Copy the URL (e.g., http://127.0.0.1:54321)
# Paste in browser
```

**You should see:** VehicleVault application! 🎉

---

## **STEP 8: Test the Application**

1. **Dashboard** - Should show 0 vehicles, 0 documents
2. **Add Vehicle** - Try adding a test vehicle
3. **Upload Document** - Try uploading a test document
4. **System Status** - Should show all systems healthy

---

## **Useful Commands**

### View Logs:
```powershell
# Frontend logs
kubectl logs -l component=frontend

# Backend logs
kubectl logs -l component=backend

# MongoDB logs
kubectl logs -l component=mongodb

# Follow logs (real-time)
kubectl logs -f -l component=backend
```

### Check Pod Details:
```powershell
# Describe a pod
kubectl describe pod <pod-name>

# Get pod name
kubectl get pods
```

### Port Forward (Alternative Access):
```powershell
# Forward frontend port
kubectl port-forward service/frontend 8080:80

# Access at: http://localhost:8080
```

### Restart a Deployment:
```powershell
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/backend
kubectl rollout restart deployment/mongodb
```

### Scale Replicas:
```powershell
# Scale backend to 2 replicas
kubectl scale deployment/backend --replicas=2

# Scale frontend to 3 replicas
kubectl scale deployment/frontend --replicas=3
```

### Check Resource Usage:
```powershell
kubectl top pods
kubectl top nodes
```

---

## **Troubleshooting**

### Pod Not Starting (CrashLoopBackOff):
```powershell
# Check pod status
kubectl get pods

# Check pod logs
kubectl logs <pod-name>

# Describe pod for events
kubectl describe pod <pod-name>
```

### Image Pull Errors:
```powershell
# Verify images exist on Docker Hub
# Check: https://hub.docker.com/r/venkatarupesh123/vehiclevault-frontend
# Check: https://hub.docker.com/r/venkatarupesh123/vehiclevault-backend

# If image doesn't exist, push again:
# cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant
# .\PUSH_TO_DOCKERHUB.bat
```

### Service Not Accessible:
```powershell
# Check if service exists
kubectl get services

# Check service details
kubectl describe service frontend

# Check if pods are running
kubectl get pods

# Try port-forward instead
kubectl port-forward service/frontend 8080:80
```

### MongoDB Connection Issues:
```powershell
# Check MongoDB logs
kubectl logs -l component=mongodb

# Check backend logs
kubectl logs -l component=backend

# Check if MongoDB service exists
kubectl get service mongodb

# Test connection from backend pod
kubectl exec -it <backend-pod-name> -- sh
# Inside pod:
# curl mongodb:27017
```

### Storage Issues:
```powershell
# Check PVCs
kubectl get pvc

# If PVC is Pending, check events
kubectl describe pvc mongodb-pvc
kubectl describe pvc uploads-pvc

# Delete and recreate if needed
kubectl delete pvc mongodb-pvc
kubectl apply -f mongodb-pvc.yaml
```

---

## **Updating the Application**

### When you make code changes:

1. **Build and push new images:**
```powershell
cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant
.\PUSH_TO_DOCKERHUB.bat
```

2. **Restart deployments in Minikube:**
```powershell
# Restart to pull latest images
kubectl rollout restart deployment/frontend
kubectl rollout restart deployment/backend
```

3. **Or force re-pull images:**
```powershell
# Delete and recreate deployments
kubectl delete -f k8s/frontend-deployment.yaml
kubectl delete -f k8s/backend-deployment.yaml

# Wait a few seconds, then apply again
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
```

---

## **Clean Up / Delete Everything**

### Delete Application:
```powershell
cd C:\Users\rushi\OneDrive\Desktop\Infoziant\Infoziant\k8s

# Delete all resources
kubectl delete -f frontend-service.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f backend-service.yaml
kubectl delete -f backend-deployment.yaml
kubectl delete -f mongodb-service.yaml
kubectl delete -f mongodb-deployment.yaml
kubectl delete -f uploads-pvc.yaml
kubectl delete -f mongodb-pvc.yaml
```

### Or delete everything at once:
```powershell
kubectl delete all --all
kubectl delete pvc --all
```

### Stop Minikube:
```powershell
minikube stop
```

### Delete Minikube cluster:
```powershell
minikube delete
```

---

## **Architecture Overview**

```
┌─────────────────────────────────────────┐
│           Minikube Cluster              │
│                                         │
│  ┌──────────────┐                      │
│  │   Frontend   │  (NodePort Service)  │───┐
│  │   Pod        │  Port 80             │   │
│  │  venkatarupesh123/                  │   │
│  │  vehiclevault-frontend:latest       │   │
│  └──────────────┘                      │   │
│         │                               │   │
│         │ HTTP /api/* requests          │   │
│         ↓                               │   │
│  ┌──────────────┐                      │   │
│  │   Backend    │  (ClusterIP Service) │   │
│  │   Pod        │  Port 5000           │   │
│  │  venkatarupesh123/                  │   │
│  │  vehiclevault-backend:latest        │   │
│  └──────────────┘                      │   │
│         │                               │   │
│         │ MongoDB connection            │   │
│         ↓                               │   │
│  ┌──────────────┐                      │   │
│  │   MongoDB    │  (ClusterIP Service) │   │
│  │   Pod        │  Port 27017          │   │
│  │  mongo:7.0   │                      │   │
│  └──────────────┘                      │   │
│         │                               │   │
│         ↓                               │   │
│  [Persistent Storage]                   │   │
│  - mongodb-pvc (1Gi)                   │   │
│  - uploads-pvc (2Gi)                   │   │
└─────────────────────────────────────────┘   │
                                              │
        Access via: http://127.0.0.1:xxxxx ◄──┘
        (minikube service frontend --url)
```

---

## **Files Created**

All Kubernetes manifests are in the `k8s/` directory:

```
k8s/
├── mongodb-pvc.yaml           # MongoDB storage
├── mongodb-deployment.yaml    # MongoDB deployment
├── mongodb-service.yaml       # MongoDB service
├── uploads-pvc.yaml           # Uploads storage
├── backend-deployment.yaml    # Backend deployment (uses Docker Hub image)
├── backend-service.yaml       # Backend service
├── frontend-deployment.yaml   # Frontend deployment (uses Docker Hub image)
└── frontend-service.yaml      # Frontend service (NodePort)
```

---

## **Key Points**

✅ **Uses Docker Hub images** - No building in Minikube  
✅ **NodePort Service** - Frontend accessible from host  
✅ **ClusterIP Services** - Backend and MongoDB internal only  
✅ **Persistent Storage** - Data survives pod restarts  
✅ **Health Checks** - Automatic pod restart if unhealthy  
✅ **Resource Limits** - Prevents resource exhaustion  

---

## **Next Steps**

After successful Minikube deployment:

1. ✅ **Try scaling** - `kubectl scale deployment/backend --replicas=3`
2. ✅ **Monitor resources** - `kubectl top pods`
3. ✅ **View Kubernetes dashboard** - `minikube dashboard`
4. ✅ **Deploy to AWS EKS** - Use same YAML files!
5. ✅ **Set up CI/CD** - Auto-deploy on code changes

---

## **✅ Deployment Checklist**

- [ ] Minikube installed
- [ ] kubectl installed
- [ ] Minikube started: `minikube start`
- [ ] PVCs created and bound
- [ ] MongoDB deployed and running
- [ ] Backend deployed and running
- [ ] Frontend deployed and running
- [ ] Application accessible via `minikube service frontend`
- [ ] Tested adding vehicle and document
- [ ] All health checks passing

---

## **🎉 Success!**

Your VehicleVault application is now running on Kubernetes (Minikube)!

**Access URL:**
```powershell
minikube service frontend --url
```

**View Dashboard:**
```powershell
minikube dashboard
```

**Congratulations! You've completed Kubernetes deployment!** 🚀✨

