#!/bin/bash
set -euo pipefail

echo '+++ Merging web pipeline steps'


merge_steps_yaml() {
    value=$(<.ci/pipeline-web.yml)
    echo "$value"
}

merge_steps_yaml2() {
cat <<YAML
  - name: ":hammer: :linux:"
    command: ".ci/web/tests.sh"
    artifact_paths: "dist/*"
    plugins:
      - docker-compose#v3.5.0:
          config: .ci/pipeline-web-docker-compose.yml
          run: agent
          env:
            - PROJECT
            - BUILDKITE_JOB_ID
            - BUILDKITE_BUILD_ID
            - BUILDKITE_BUILD_NUMBER
  - wait
YAML
}

merge_steps_yaml2 | buildkite-agent pipeline upload
