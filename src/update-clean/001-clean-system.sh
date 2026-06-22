#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/../update-dc/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Cleaning Generic Dev Container / System"

apt-get clean
rm -rf /var/lib/apt/lists