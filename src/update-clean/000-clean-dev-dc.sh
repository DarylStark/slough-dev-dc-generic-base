#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/../update-dc/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Cleaning Generic Dev Container"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
current_script="$(basename -- "${BASH_SOURCE[0]}")"

for script in "$script_dir"/[0-9][0-9][0-9]-*.sh; do
    [[ "$(basename -- "$script")" == "$current_script" ]] && continue
    echo "==> Running $(basename -- "$script")"
    bash "$script"
done