#!/bin/bash
set -euo pipefail

# Metadata keys
PACKAGE_NAME_KEY="package_name"
FULL_VERSION_KEY="full_version"
DOCKER_REGISTRY_KEY="docker_registry"
DOCKER_REPOSITORY_KEY="docker_repository"
# Metadata
PACKAGE_NAME=$(buildkite-agent meta-data get ${PACKAGE_NAME_KEY})
FULL_VERSION=$(buildkite-agent meta-data get ${FULL_VERSION_KEY})
DOCKER_REGISTRY=$(buildkite-agent meta-data get ${DOCKER_REGISTRY_KEY})
DOCKER_REPOSITORY_NAME=$(buildkite-agent meta-data get ${DOCKER_REPOSITORY_KEY})
IMAGE_TAG="${DOCKER_REGISTRY}/${DOCKER_REPOSITORY_NAME}/${PROJECT}:${FULL_VERSION}"

echo "+++ Building docker image -> ${IMAGE_TAG}"

# Clean existing pkg
rm -rf pkg
mkdir -p pkg/app

# Login to private registry
docker login --username=${NEXUS_LOGIN_USER} --password=${NEXUS_LOGIN_PASSWORD} ${DOCKER_REGISTRY}

# Download the package
#buildkite-agent artifact download "${PACKAGE_NAME}.tar.gz" .
#tar -czxf ./${PACKAGE_NAME}.tar.gz --directory ./pkg/app

aws s3 cp s3://mti-ci-artifacts/85/dist/ptg-mobile-1.4.85.tar.gz ptg-mobile-1.4.85.tar.gz
tar zxf ./ptg-mobile-1.4.85.tar.gz --directory ./pkg/app

cp .ci/web/Dockerfile ./pkg/Dockerfile
cp .ci/web/nginx.conf ./pkg/nginx.conf
docker build --tag ${IMAGE_TAG} ./pkg
docker push ${IMAGE_TAG}
