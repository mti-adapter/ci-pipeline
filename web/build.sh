#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

BASE_DIRECTORY=`pwd`
PACKAGE_FILENAME="$PROJECT.tar.gz"
TMP_DIRECTORY=$BASE_DIRECTORY/tmp

# Ensure the tmp release directory exists
rm -rf $TMP_DIRECTORY
mkdir -p $TMP_DIRECTORY

echo '+++ Running npm install'
npm install
npm install -g @angular/cli@~${NG_CLI_VERSION:-9.1.5}
echo '+++ Running npm build'
npm run build -- --output-path="$TMP_DIRECTORY"
echo '+++ Generating artifact'
tar -zcvf "./dist/$PACKAGE_FILENAME" "$TMP_DIRECTORY"

