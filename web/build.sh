#!/bin/bash
set -euo pipefail

export NG_CLI_ANALYTICS=ci

echo '+++ Running npm install'
npm install
echo '+++ Running npm build'
npm run build -- --output-path=./dist
echo '+++ Generating package'
ls -la ./dist
