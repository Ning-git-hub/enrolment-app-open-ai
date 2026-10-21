#!/bin/bash
set -e

# Creates the Container Apps environment
# (run scripts/lab11/build-images.sh first, scripts/lab11/deploy-azure.sh after).
# Kept separate from deploy-azure.sh for OIDC token timing.

echo "=== Lab 11 Container Apps Environment ==="

RESOURCE_GROUP="${RESOURCE_GROUP:-lab11-rg}"

# Step 1: Read deployment names from resource group tags
ENV_NAME=$(az group show \
  --name "$RESOURCE_GROUP" \
  --query "tags.envName" \
  -o tsv)

LOCATION=$(az group show \
  --name "$RESOURCE_GROUP" \
  --query "tags.location" \
  -o tsv)

if [[ -z "$ENV_NAME" || -z "$LOCATION" ]]; then
  echo "Resource group $RESOURCE_GROUP is missing deployment tags. Run scripts/lab11/env-setup.sh first." >&2
  exit 1
fi

# Step 2: Create Container Apps environment
echo "Creating Container Apps environment..."

az containerapp env create \
  --name "$ENV_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION"

echo "=== Container Apps Environment Ready ==="