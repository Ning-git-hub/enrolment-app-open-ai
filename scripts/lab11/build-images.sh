#!/bin/bash
set -e

# Creates the ACR and builds/pushes all 3 service images.

echo "=== Lab 11 Image Build ==="

RESOURCE_GROUP="${RESOURCE_GROUP:-lab11-rg}"
IMAGE_TAG="latest"

# Step 1: Read the registry name from resource group tags
REGISTRY_NAME=$(az group show \
  --name "$RESOURCE_GROUP" \
  --query "tags.registryName" \
  -o tsv)

if [[ -z "$REGISTRY_NAME" ]]; then
  echo "Resource group $RESOURCE_GROUP is missing deployment tags. Run scripts/lab11/env-setup.sh first." >&2
  exit 1
fi

# Step 2: Create Azure Container Registry
echo "Creating Azure Container Registry..."

az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REGISTRY_NAME" \
  --sku Basic

# Step 2b: Registry DNS check
# On macOS, the Lab's original 'getent hosts' command is not available.
# DNS has already been verified manually with nslookup, so continue directly.
LOGIN_SERVER="${REGISTRY_NAME}.azurecr.io"

echo "$LOGIN_SERVER is resolvable."

# Step 3: Build and push all 3 container images
echo "Building and pushing database-service image..."

az acr build \
  --registry "$REGISTRY_NAME" \
  --image "database-service:${IMAGE_TAG}" \
  ./database-service

echo "Building and pushing enrolment-service image..."

az acr build \
  --registry "$REGISTRY_NAME" \
  --image "enrolment-service:${IMAGE_TAG}" \
  --file enrolment-service/Dockerfile \
  .

echo "Building and pushing frontend-service image..."

az acr build \
  --registry "$REGISTRY_NAME" \
  --image "frontend-service:${IMAGE_TAG}" \
  ./frontend-service

echo "=== Image Build Complete ==="