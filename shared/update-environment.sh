#!/bin/bash
set -euo pipefail

echo "+++ Updating environment"

# Provided major version or use 1
MAJOR_VERSION_NUMBER=${MAJOR_VERSION:-1}
DOCKER_REGISTRY_HOST=${DOCKER_REGISTRY:-"containers.amphoratech.net"}
DOCKER_REPOSITORY_NAME=${DOCKER_REPOSITORY:-"mti"}
# Metadata keys
MINOR_VERSION_KEY="minor_version"
FULL_VERSION_KEY="full_version"
PACKAGE_NAME_KEY="package_name"
DOCKER_REGISTRY_KEY="docker_registry"
DOCKER_REPOSITORY_KEY="docker_repository"
VERSION_FILENAME="${PROJECT}.txt"
# Get the current minor version number or fail
! aws s3 cp s3://mti-ci-artifacts/versions/${VERSION_FILENAME} ${VERSION_FILENAME}
MINOR_VERSION_NUMBER=$(cat ${VERSION_FILENAME} || echo "fail")
# If failed then set to 0
if [[ ${MINOR_VERSION_NUMBER} == "fail" ]]; then
    echo 'Setting initial minor version number to 0'
    MINOR_VERSION_NUMBER=0
else
    # Only increment the minor version if the branch name starts with feature/
    # Copy the value for printing
    minorVersionNumberCopy=${MINOR_VERSION_NUMBER}
    # Increment minor version number if this is a feature and save it in an artifact
    MINOR_VERSION_NUMBER=$((${MINOR_VERSION_NUMBER}+1))
    # print change
    echo "Minor version number: ${minorVersionNumberCopy} -> ${MINOR_VERSION_NUMBER}"
fi
# Write the new version to text file
echo "${MINOR_VERSION_NUMBER}" > ${PROJECT}.txt
# Store the new version number
buildkite-agent artifact upload ${VERSION_FILENAME} s3://mti-ci-artifacts/versions --job ${BUILDKITE_JOB_ID}
# Store minor version in metadata
buildkite-agent meta-data set ${MINOR_VERSION_KEY} ${MINOR_VERSION_NUMBER}
# Build the full version number
VERSION_NUMBER="${MAJOR_VERSION_NUMBER}.${MINOR_VERSION_NUMBER}.${BUILDKITE_BUILD_NUMBER}"
# Store full version in metadata
buildkite-agent meta-data set ${FULL_VERSION_KEY} ${VERSION_NUMBER}
# Set docker registry host
buildkite-agent meta-data set ${DOCKER_REGISTRY_KEY} ${DOCKER_REGISTRY_HOST}
buildkite-agent meta-data set ${DOCKER_REPOSITORY_KEY} ${DOCKER_REPOSITORY_NAME}
