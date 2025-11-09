#!/bin/bash

set -eou pipefail

if ! bundle exec bundle-audit check --update; then
    echo "One or more dependencies contain known vulnerabilities" 1>&2
    exit 1
fi

# required
rm -f .b4.lock
