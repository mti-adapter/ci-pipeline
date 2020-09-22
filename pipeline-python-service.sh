#!/bin/bash
set -euo pipefail

echo '+++ Merging go service pipeline steps'


merge_steps_yaml() {
    value=$(<.ci/pipeline-python-service.yml)
    echo "$value"
}

# Set environments, process version upgrades etc.
./.ci/shared/update-environment.sh

merge_steps_yaml | buildkite-agent pipeline upload
