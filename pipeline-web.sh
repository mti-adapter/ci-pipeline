#!/bin/bash
set -euo pipefail

echo '+++ Merging web pipeline steps'


merge_steps_yaml() {
    value=$(<.ci/pipeline-web.yml)
    echo "$value"
}

# Set environments, process version upgrades etc.
./.ci/web/update-environment.sh

merge_steps_yaml | buildkite-agent pipeline upload
