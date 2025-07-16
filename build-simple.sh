#!/bin/bash

# Build simple custom Open WebUI image
set -e

DOCKER_USERNAME="sixtyoneeighty"
IMAGE_NAME="open-webui-simple"
TAG="latest"
FULL_IMAGE_NAME="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🏗️  Building simple custom Open WebUI image..."
echo "📦 Image: ${FULL_IMAGE_NAME}"

# Build for multiple platforms
docker buildx create --name simple-builder --use 2>/dev/null || docker buildx use simple-builder

read -p "🚀 Build and push to Docker Hub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔐 Logging into Docker Hub..."
    docker login
    
    echo "📤 Building and pushing simple image..."
    docker buildx build \
      --platform linux/amd64,linux/arm64 \
      -f Dockerfile.simple \
      -t ${FULL_IMAGE_NAME} \
      --push \
      .
    
    echo "✅ Simple image pushed successfully!"
    echo "🎉 Available at: https://hub.docker.com/r/${FULL_IMAGE_NAME}"
else
    echo "📦 Building locally..."
    docker build -f Dockerfile.simple -t ${FULL_IMAGE_NAME} .
    echo "🔧 Test: docker run -p 8080:8080 ${FULL_IMAGE_NAME}"
fi