#!/bin/bash

# Build and push custom Open WebUI image to Docker Hub (multi-platform)
# Usage: ./build-custom-image.sh [your-dockerhub-username]

set -e

# Configuration
DOCKER_USERNAME=${1:-"sixtyoneeighty"}
IMAGE_NAME="open-webui-custom"
TAG="latest"
FULL_IMAGE_NAME="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🏗️  Building custom Open WebUI image for multiple platforms..."
echo "📦 Image: ${FULL_IMAGE_NAME}"
echo "🔧 Platforms: linux/amd64,linux/arm64"

# Create and use buildx builder if it doesn't exist
docker buildx create --name multiplatform --use 2>/dev/null || docker buildx use multiplatform

# Ask if user wants to push
read -p "🚀 Build and push to Docker Hub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔐 Logging into Docker Hub..."
    docker login
    
    echo "📤 Building and pushing multi-platform image..."
    docker buildx build \
      --platform linux/amd64,linux/arm64 \
      -f Dockerfile.custom \
      -t ${FULL_IMAGE_NAME} \
      --build-arg BUILD_HASH="custom-$(date +%Y%m%d-%H%M%S)" \
      --push \
      .
    
    echo "✅ Multi-platform image pushed successfully!"
    echo "🎉 Your custom image is available at: https://hub.docker.com/r/${FULL_IMAGE_NAME}"
    echo "🔧 Supports: linux/amd64 (HuggingFace) and linux/arm64 (Apple Silicon)"
    echo ""
    echo "📋 Your HuggingFace Dockerfile is ready to use:"
    echo "FROM ${FULL_IMAGE_NAME}"
    echo "ENV PORT=7860"
    echo "ENV HOST=0.0.0.0"
    echo "EXPOSE 7860"
    echo "CMD [\"bash\", \"/app/backend/start.sh\"]"
else
    echo "📦 Building locally for current platform..."
    docker build -f Dockerfile.custom -t ${FULL_IMAGE_NAME} \
      --build-arg BUILD_HASH="custom-$(date +%Y%m%d-%H%M%S)" \
      .
    echo "🔧 To test locally: docker run -p 8080:8080 ${FULL_IMAGE_NAME}"
    echo ""
    echo "⚠️  Note: This local build won't work on HuggingFace Spaces."
    echo "   Run the script again and choose 'y' to build for multiple platforms."
fi