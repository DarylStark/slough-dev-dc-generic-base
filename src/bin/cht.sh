#!/usr/bin/env bash

# This is the official cheat.sh client script
# Original source: https://github.com/chubin/cheat.sh
# Usage: cht.sh [options] [query]

# Configuration
CHTSH_URL=${CHTSH_URL:-https://cht.sh}
CHTSH_QUERY_OPTIONS="style=bw"

# Color definitions
if [[ -t 1 ]]; then
    # We're in a terminal, use colors
    CHTSH_QUERY_OPTIONS=""
fi

# Help message
show_help() {
    cat << EOF
Usage: cht.sh [options] [query]

A command-line client for cheat.sh - the only cheat sheet you need.

Options:
  -h, --help       Show this help message
  -q, --query      Query cheat.sh directly
  -s, --shell      Start interactive shell mode (requires rlwrap)
  -l, --list       List available cheat sheets

Examples:
  cht.sh tar                  # Show tar cheat sheet
  cht.sh python zip           # Show how to use zip in python
  cht.sh go/reverse a list    # Search for "reverse a list" in go
  cht.sh --shell              # Interactive mode

Environment Variables:
  CHTSH_URL                   Override the default cheat.sh URL
                              (default: https://cht.sh)

For more information, visit: https://github.com/chubin/cheat.sh
EOF
}

# Function to query cheat.sh
query_chtsh() {
    local query="$*"
    # URL encode the query by replacing spaces with +
    query="${query// /+}"
    local url="${CHTSH_URL}/${query}"

    if [[ -n "$CHTSH_QUERY_OPTIONS" ]]; then
        url="${url}?${CHTSH_QUERY_OPTIONS}"
    fi

    if ! curl -sf "$url"; then
        echo "Error: Failed to fetch data from cheat.sh" >&2
        return 1
    fi
}

# Function to start interactive shell
interactive_shell() {
    if command -v rlwrap >/dev/null 2>&1; then
        echo "Starting interactive cheat.sh shell..."
        echo "Type 'help' for help, 'exit' or Ctrl-D to exit"
        rlwrap -H ~/.cht.sh_history -P "cht.sh> " bash -c '
            while IFS="" read -r -e -p "" query; do
                [[ "$query" == "exit" ]] && break
                [[ -z "$query" ]] && continue
                [[ "$query" == "help" ]] && { echo "Type any query to search cheat.sh"; continue; }
                '"$0"' "$query"
            done
        '
    else
        echo "Error: rlwrap is required for interactive mode but not installed."
        echo "Install it with: sudo apt-get install rlwrap"
        exit 1
    fi
}

# Function to list available cheat sheets
list_sheets() {
    query_chtsh ":list"
}

# Main script logic
main() {
    # Parse arguments
    case "${1}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--shell)
            interactive_shell
            exit 0
            ;;
        -l|--list)
            list_sheets
            exit 0
            ;;
        -q|--query)
            shift
            query_chtsh "$@"
            exit 0
            ;;
        "")
            show_help
            exit 0
            ;;
        *)
            query_chtsh "$@"
            exit 0
            ;;
    esac
}

# Run main function
main "$@"
