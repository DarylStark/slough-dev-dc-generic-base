#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Updating Generic Dev Container / System"

# System packages
sudo apt update && \
    apt full-upgrade -y --no-install-recommends

