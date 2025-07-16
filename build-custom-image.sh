#!/bin/bash

# Build and push custom Open WebUI image to Docker Hub
# Usage: ./build-custom-image.sh [your-dockerhub-username]

set -e

# Configuration
DOCKER_USERNAME=${1:-"sixtyoneeighty"}
IMAGE_NAME="open-webui-custom"
TAG="latest"
FULL_IMAGE_NAME="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🏗️  Building custom Open WebUI image..."
echo "📦 Image: ${FULL_IMAGE_NAME}"

# Build the image
docker build -f Dockerfile.custom -t ${FULL_IMAGE_NAME} \
  --build-arg BUILD_HASH="custom-$(date +%Y%m%d-%H%M%S)" \
  .

echo "✅ Build completed!"

# Ask if user wants to push
read -p "🚀 Push to Docker Hub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔐 Logging into Docker Hub..."
    docker login
    
    echo "📤 Pushing image..."
    docker push ${FULL_IMAGE_NAME}
    
    echo "✅ Image pushed successfully!"
    echo "🎉 Your custom image is available at: https://hub.docker.com/r/${FULL_IMAGE_NAME}"
    echo ""
    echo "📋 Your HuggingFace Dockerfile is ready to use:"
    echo "FROM ${FULL_IMAGE_NAME}"
    echo "ENV PORT=7860"
    echo "ENV HOST=0.0.0.0"
    echo "EXPOSE 7860"
    echo "CMD [\"bash\", \"/app/backend/start.sh\"]"
else
    echo "📦 Image built locally as: ${FULL_IMAGE_NAME}"
    echo "🔧 To test locally: docker run -p 8080:8080 ${FULL_IMAGE_NAME}"
fi