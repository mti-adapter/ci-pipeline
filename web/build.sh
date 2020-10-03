#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

# Variables
BASE_DIRECTORY=`pwd`
PACKAGE_FILENAME="$PROJECT"
TMP_DIRECTORY=$BASE_DIRECTORY/build
DIST_DIRECTOR='./dist'
MAJOR_VERSION_NUMBER=${MAJOR_VERSION:-1}
# Metadata
VERSION_NUMBER=$(buildkite-agent meta-data get "full_version")

# Ensure the tmp release directory exists
rm -rf ${TMP_DIRECTORY}
rm -rf ${DIST_DIRECTOR}
mkdir -p ${TMP_DIRECTORY}
mkdir -p ${DIST_DIRECTOR}

# Build & Package
echo '+++ Running npm install'
npm install
npm install -g @angular/cli@~${NG_CLI_VERSION:-9.1.5}
echo '+++ Running npm build'
echo "Extra build options ${BUILD_OPTS:-}"
npm run build -- --output-path=${TMP_DIRECTORY} -- ${BUILD_OPTS:-}
tar czf ${DIST_DIRECTOR}/${PACKAGE_FILENAME}.tar.gz --directory=${TMP_DIRECTORY} .
cd ${DIST_DIRECTOR}
buildkite-agent artifact upload ${PACKAGE_FILENAME}.tar.gz s3://mti-ci-artifacts/${PROJECT}/${VERSION_NUMBER}
cd ${BASE_DIRECTORY}
