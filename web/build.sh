#!/bin/bash
set -euo pipefail

echo '+++ Running npm build'

npm install
npm run build -- --output-path=./dist
ls -la ./dist
