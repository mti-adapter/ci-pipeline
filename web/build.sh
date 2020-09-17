#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

echo '+++ Running npm install'
npm install
npm install -g @angular/cli@~${NG_CLI_VERSION:9.1.5}
echo '+++ Running npm build'
npm run build -- --output-path=./dist
echo '+++ Generating package'
ls -la ./dist
