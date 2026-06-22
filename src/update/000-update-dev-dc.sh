#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Updating Generic Dev Container"

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export UC_ANSWERS=keep

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
current_script="$(basename -- "${BASH_SOURCE[0]}")"

for script in "$script_dir"/[0-9][0-9][0-9]-*.sh; do
    [[ "$(basename -- "$script")" == "$current_script" ]] && continue
    echo "==> Running $(basename -- "$script")"
    bash "$script"
done