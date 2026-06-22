#!/bin/bash

set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lib_dir="$(cd -- "$script_dir/lib" && pwd)"
source "$lib_dir/common.sh"

require_root
print_header "Updating Generic Dev Container / StarShip"

# Starship
wget -q https://starship.rs/install.sh -O /tmp/install-starship.sh && \
    chmod +x /tmp/install-starship.sh && \
    /tmp/install-starship.sh -y && \
    rm /tmp/install-starship.sh
