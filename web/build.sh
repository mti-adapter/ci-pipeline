#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

BASE_DIRECTORY=`pwd`
PACKAGE_FILENAME="$PROJECT"
TMP_DIRECTORY=$BASE_DIRECTORY/build
DIST_DIRECTOR='./dist'
MAJOR_VERSION_NUMBER=${MAJOR_VERSION:-1}

# Ensure the tmp release directory exists
rm -rf ${TMP_DIRECTORY}
mkdir -p ${TMP_DIRECTORY}
mkdir ${DIST_DIRECTOR}

# Fetch version artifact for this project, if it does not exist then
# create it starting with MAJOR_VERSION.0.BUILD_NUMBER
MINOR_VERSION_KEY="minor_version"
MINOR_VERSION_KEY_EXISTS=$(buildkite-agent meta-data exists ${MINOR_VERSION_KEY})

if [[ VERSION_KEY_EXISTS == 100 ]]; then
    echo '+++ Setting initial minor version number to 0'
    buildkite-agent meta-data set ${MINOR_VERSION_KEY} 0
fi

# get the current minor version number and increment it
export MINOR_VERSION_NUMBER=$(buildkite-agent meta-data get "${MINOR_VERSION_KEY}")
export MINOR_VERSION_NUMBER=${MINOR_VERSION_NUMBER}+1
export VERSION_NUMBER="${MAJOR_VERSION_NUMBER}.${MINOR_VERSION_NUMBER}.${BUILDKITE_BUILD_NUMBER}"
buildkite-agent meta-data set ${MINOR_VERSION_KEY} ${MINOR_VERSION_NUMBER}

echo '+++ Running npm install'
npm install
npm install -g @angular/cli@~${NG_CLI_VERSION:-9.1.5}
echo '+++ Running npm build'
npm run build -- --output-path=${TMP_DIRECTORY}
echo '+++ Generating artifact'
cd ${TMP_DIRECTORY}
tar -zcvf ${BASE_DIRECTORY}/dist/${PACKAGE_FILENAME}-${VERSION_NUMBER}.tar.gz .
cd ${BASE_DIRECTORY}
