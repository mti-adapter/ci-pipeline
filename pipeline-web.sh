#!/bin/bash
set -euo pipefail

echo '+++ Merging web pipeline steps'


merge_steps_yaml() {
    value=$(<pipeline-web-docker-compose.yml)
    echo "$value"
}

merge_steps_yaml | buildkite-agent pipeline upload
