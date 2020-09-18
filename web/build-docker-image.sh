#!/bin/bash
set -euo pipefail

# Metadata keys
PACKAGE_NAME_KEY="package_name"
FULL_VERSION_KEY="full_version"
DOCKER_REGISTRY_KEY="docker_registry"
# Metadata
PACKAGE_NAME=$(buildkite-agent meta-data get ${PACKAGE_NAME_KEY})
FULL_VERSION=$(buildkite-agent meta-data get ${FULL_VERSION_KEY})
DOCKER_REGISTRY=$(buildkite-agent meta-data get ${DOCKER_REGISTRY_KEY})
IMAGE_TAG="${DOCKER_REGISTRY}/${PROJECT}:${FULL_VERSION}"

echo "+++ Building docker image -> ${IMAGE_TAG}"

# Clean existing pkg
rm -rf pkg
mkdir -p pkg/app

# Download the package
#buildkite-agent artifact download "${PACKAGE_NAME}.tar.gz" .
#tar -czxf ./${PACKAGE_NAME}.tar.gz --directory ./pkg/app
aws s3 cp s3://mti-ci-artifacts/versions/85 dist/ptg-mobile-1.4.85.tar.gz
tar -czxf ./ptg-mobile-1.4.85.tar.gz --directory ./pkg/app
cp ./web/Dockerfile ./pkg/Dockerfile
docker build --tag ${IMAGE_TAG} ./pkg
docker push ${IMAGE_TAG}
