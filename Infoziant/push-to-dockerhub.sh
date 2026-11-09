#!/bin/bash
# VehicleVault - Push to Docker Hub
# Run this on EC2 server

echo "🐳 VehicleVault - Docker Hub Push Script"
echo "========================================"
echo ""

# Ask for Docker Hub username
read -p "Enter your Docker Hub username: " DOCKER_USERNAME
read -p "Enter version tag (e.g., v1.0.0): " VERSION

echo ""
echo "📦 Configuration:"
echo "   Username: $DOCKER_USERNAME"
echo "   Version: $VERSION"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Navigate to project
cd /opt/vehiclevault

echo ""
echo "🔨 Building images..."
docker compose build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "🏷️  Tagging images..."
docker tag vehiclevault-frontend $DOCKER_USERNAME/vehiclevault-frontend:latest
docker tag vehiclevault-frontend $DOCKER_USERNAME/vehiclevault-frontend:$VERSION
docker tag vehiclevault-backend $DOCKER_USERNAME/vehiclevault-backend:latest
docker tag vehiclevault-backend $DOCKER_USERNAME/vehiclevault-backend:$VERSION

echo ""
echo "📋 Images tagged:"
docker images | grep "$DOCKER_USERNAME/vehiclevault"

echo ""
echo "🚀 Pushing to Docker Hub..."
echo "   (This may take 5-10 minutes...)"
echo ""

docker push $DOCKER_USERNAME/vehiclevault-frontend:latest
docker push $DOCKER_USERNAME/vehiclevault-frontend:$VERSION
docker push $DOCKER_USERNAME/vehiclevault-backend:latest
docker push $DOCKER_USERNAME/vehiclevault-backend:$VERSION

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Images pushed to Docker Hub"
    echo ""
    echo "🌐 View your images at:"
    echo "   https://hub.docker.com/u/$DOCKER_USERNAME"
    echo ""
    echo "📥 Pull command:"
    echo "   docker pull $DOCKER_USERNAME/vehiclevault-frontend:$VERSION"
    echo "   docker pull $DOCKER_USERNAME/vehiclevault-backend:$VERSION"
else
    echo ""
    echo "❌ Push failed!"
    echo "Make sure you're logged in: docker login"
fi
