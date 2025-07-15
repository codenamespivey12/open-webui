#!/bin/bash

# Build and push to GitHub Container Registry
# Usage: ./build-and-push-ghcr.sh [your-github-username]

set -e

# Configuration
GITHUB_USERNAME=${1:-"your-github-username"}
IMAGE_NAME="open-webui-custom"
TAG="latest"
FULL_IMAGE_NAME="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🏗️  Building custom Open WebUI image for GHCR..."
echo "📦 Image: ${FULL_IMAGE_NAME}"

# Build the image
docker build -f Dockerfile.custom -t ${FULL_IMAGE_NAME} \
  --build-arg BUILD_HASH="custom-$(date +%Y%m%d-%H%M%S)" \
  .

echo "✅ Build completed!"

# Ask if user wants to push
read -p "🚀 Push to GitHub Container Registry? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔐 Logging into GitHub Container Registry..."
    echo "💡 You'll need a GitHub Personal Access Token with 'write:packages' permission"
    docker login ghcr.io
    
    echo "📤 Pushing image..."
    docker push ${FULL_IMAGE_NAME}
    
    echo "✅ Image pushed successfully!"
    echo "🎉 Your custom image is available at: ${FULL_IMAGE_NAME}"
    echo ""
    echo "📋 To use in HuggingFace Spaces, create a Dockerfile with:"
    echo "FROM ${FULL_IMAGE_NAME}"
    echo "ENV PORT=7860"
    echo "ENV HOST=0.0.0.0"
    echo "EXPOSE 7860"
    echo "CMD [\"bash\", \"/app/backend/start.sh\"]"
else
    echo "📦 Image built locally as: ${FULL_IMAGE_NAME}"
    echo "🔧 To test locally: docker run -p 8080:8080 ${FULL_IMAGE_NAME}"
fi