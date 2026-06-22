#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Updating Generic Dev Container / Dev Tools"

# All UV installed tools
sudo -u developer /home/developer/.local/bin/uv tool upgrade --all