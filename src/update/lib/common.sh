#!/usr/bin/env bash

require_root() {
    if [ "$(id --user)" != "0" ]; then
        echo "This should be run as root. Please prefix it with \"sudo\"."
        exit 1
    fi
}

print_header() {
    local title="${1:-}"
    echo "+-----------------------------------------------------------------------+"
    printf '| %-69s |\n' "$title"
    echo "+-----------------------------------------------------------------------+"
}