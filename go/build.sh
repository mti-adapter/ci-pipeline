#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

# Variables
BASE_DIRECTORY=`pwd`
TMP_DIRECTORY=$BASE_DIRECTORY/build
DIST_DIRECTOR='./dist'
MAJOR_VERSION_NUMBER=${MAJOR_VERSION:-1}
# Binary type
export GOOS=${1}
export GOARCH=${2}
# Metadata
VERSION_NUMBER=$(buildkite-agent meta-data get "full_version")

if [[ "$GOARCH" = "armhf" ]]; then
  export GOARCH="arm"
  export GOARM="7"
fi

echo "GOOS=$GOOS"
echo "GOARCH=$GOARCH"
if [[ -n "$GOARM" ]]; then
  echo "GOARM=$GOARM"
fi

# Package name
PACKAGE_FILENAME=${PROJECT}-${GOOS}-${GOARCH}-${VERSION_NUMBER}

# Add .exe for Windows builds
if [[ "$GOOS" == "windows" ]]; then
  PACKAGE_FILENAME="$PACKAGE_FILENAME.exe"
fi

# Disable CGO completely
export CGO_ENABLED=0

# Ensure the tmp release directory exists
rm -rf ${TMP_DIRECTORY}
mkdir -p ${TMP_DIRECTORY}
mkdir ${DIST_DIRECTOR}

# Build & Package
echo '+++ Running go build'
go build -v -o ${TMP_DIRECTORY}/${PACKAGE_FILENAME} *.go
cd ${TMP_DIRECTORY}
tar -zcf ${BASE_DIRECTORY}/dist/${PACKAGE_FILENAME}.tar.gz .
cd ${BASE_DIRECTORY}
