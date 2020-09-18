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
mkdir -p ${TMP_DIRECTORY}
mkdir ${DIST_DIRECTOR}

# Build & Package
echo '+++ Running npm install'
npm install
npm install -g @angular/cli@~${NG_CLI_VERSION:-9.1.5}
echo '+++ Running npm build'
npm run build -- --output-path=${TMP_DIRECTORY}
cd ${TMP_DIRECTORY}
tar -zcf ${BASE_DIRECTORY}/dist/${PACKAGE_FILENAME}-${VERSION_NUMBER}.tar.gz .
cd ${BASE_DIRECTORY}
