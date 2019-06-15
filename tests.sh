#!/bin/bash

set -euo pipefail
set -o xtrace

curl --version
git --version
shellcheck --version
gcc --version

shellcheck tests.sh
