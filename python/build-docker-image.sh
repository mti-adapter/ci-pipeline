#!/bin/bash
set -euo pipefail

# Metadata keys
FULL_VERSION_KEY="full_version"
DOCKER_REGISTRY_KEY="docker_registry"
DOCKER_REPOSITORY_KEY="docker_repository"
# Metadata
FULL_VERSION=$(buildkite-agent meta-data get ${FULL_VERSION_KEY})
DOCKER_REGISTRY=$(buildkite-agent meta-data get ${DOCKER_REGISTRY_KEY})
DOCKER_REPOSITORY_NAME=$(buildkite-agent meta-data get ${DOCKER_REPOSITORY_KEY})
IMAGE_TAG="${DOCKER_REGISTRY}/${DOCKER_REPOSITORY_NAME}/${PROJECT}:${FULL_VERSION}"
# Package name
PACKAGE_NAME=${PROJECT}

echo "+++ Building docker image -> ${IMAGE_TAG}"

# Login to private registry
docker login --username=${NEXUS_LOGIN_USER} --password=${NEXUS_LOGIN_PASSWORD} ${DOCKER_REGISTRY}

cp .ci/go/Dockerfile ./Dockerfile
docker build --tag ${IMAGE_TAG} ./pkg
docker push ${IMAGE_TAG}
