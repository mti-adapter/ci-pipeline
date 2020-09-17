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

# Minor version key
MINOR_VERSION_KEY="minor_version"
# Get the current minor version number or fail
MINOR_VERSION_NUMBER=$(buildkite-agent meta-data get "${MINOR_VERSION_KEY}" --default "fail")
# If failed then set to 0
if [[ ${MINOR_VERSION_NUMBER} == "fail" ]]; then
    echo '+++ Setting initial minor version number to 0'
    MINOR_VERSION_NUMBER=0
    buildkite-agent meta-data set "${MINOR_VERSION_KEY}" ${MINOR_VERSION_NUMBER}
fi

# Increment version number
MINOR_VERSION_NUMBER=${MINOR_VERSION_NUMBER}+1
VERSION_NUMBER="${MAJOR_VERSION_NUMBER}.${MINOR_VERSION_NUMBER}.${BUILDKITE_BUILD_NUMBER}"
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
