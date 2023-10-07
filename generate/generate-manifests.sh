#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
deploykf generate \
    --source-version "0.1.2" \
    --values ${SCRIPT_DIR}/dev-values.yaml \
    --output-dir ${SCRIPT_DIR}/manifests
