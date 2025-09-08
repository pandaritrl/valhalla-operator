#!/bin/bash

# Configuration
USERNAME=pandaritrl
REGISTRY=ghcr.io
TAG=latest

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if GHCR_TOKEN is set
if [ -z "$GHCR_TOKEN" ]; then
    print_error "GHCR_TOKEN environment variable is not set"
    exit 1
fi

# Login to GitHub Container Registry
print_status "Logging in to GitHub Container Registry..."
echo ${GHCR_TOKEN} | docker login ${REGISTRY} -u ${USERNAME} --password-stdin

if [ $? -ne 0 ]; then
    print_error "Failed to login to GitHub Container Registry"
    exit 1
fi

print_status "Successfully logged in to GitHub Container Registry"

# Build and push valhalla-builder image
print_status "Building valhalla-builder image..."
cd docker/builder
docker build -t ${REGISTRY}/${USERNAME}/valhalla-builder:${TAG} .

if [ $? -ne 0 ]; then
    print_error "Failed to build valhalla-builder image"
    exit 1
fi

print_status "Pushing valhalla-builder image..."
docker push ${REGISTRY}/${USERNAME}/valhalla-builder:${TAG}

if [ $? -ne 0 ]; then
    print_error "Failed to push valhalla-builder image"
    exit 1
fi

print_status "Successfully built and pushed valhalla-builder:${TAG}"

# Return to root directory
cd ../..

# Build and push valhalla-worker image
print_status "Building valhalla-worker image..."
cd docker/worker
docker build -t ${REGISTRY}/${USERNAME}/valhalla-worker:${TAG} .

if [ $? -ne 0 ]; then
    print_error "Failed to build valhalla-worker image"
    exit 1
fi

print_status "Pushing valhalla-worker image..."
docker push ${REGISTRY}/${USERNAME}/valhalla-worker:${TAG}

if [ $? -ne 0 ]; then
    print_error "Failed to push valhalla-worker image"
    exit 1
fi

print_status "Successfully built and pushed valhalla-worker:${TAG}"

# Return to root directory
cd ../..

# Build and push valhalla-predicted-traffic image
print_status "Building valhalla-predicted-traffic image..."
cd docker/predicted-traffic-fetcher
docker build -t ${REGISTRY}/${USERNAME}/valhalla-predicted-traffic:${TAG} .

if [ $? -ne 0 ]; then
    print_error "Failed to build valhalla-predicted-traffic image"
    exit 1
fi

print_status "Pushing valhalla-predicted-traffic image..."
docker push ${REGISTRY}/${USERNAME}/valhalla-predicted-traffic:${TAG}

if [ $? -ne 0 ]; then
    print_error "Failed to push valhalla-predicted-traffic image"
    exit 1
fi

print_status "Successfully built and pushed valhalla-predicted-traffic:${TAG}"

# Return to root directory
cd ../..

# Summary
print_status "All images have been successfully built and pushed to ${REGISTRY}/${USERNAME}/"
print_status "Images pushed:"
echo "  - ${REGISTRY}/${USERNAME}/valhalla-builder:${TAG}"
echo "  - ${REGISTRY}/${USERNAME}/valhalla-worker:${TAG}"
echo "  - ${REGISTRY}/${USERNAME}/valhalla-predicted-traffic:${TAG}"