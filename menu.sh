#!/usr/bin/env bash
#
# menu.sh
# AI Dash Cleaner - menu (entry point)
#
# This is a skeleton for now: the options only show a placeholder.
# The actual dash-cleaning logic (remove-ai-dashes.sh) will be wired in
# later, as its own step.
#
# Requires: Git Bash (Windows) or Bash + git (Linux/macOS)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "$PROJECT_ROOT/lib/colors.sh"
source "$PROJECT_ROOT/lib/common.sh"
source "$PROJECT_ROOT/lib/globals.sh"
source "$PROJECT_ROOT/lib/program-exit.sh"

main_menu() {
    while true; do
        print_banner
        echo "1) Scan"
        echo "2) Help"
        echo "3) About"
        echo
        echo "x) Exit"
        echo
        echo

        if ! read -rp "Choice: " choice; then
            echo
            log_warning "Input stopped, exiting."
            graceful_exit
        fi

        case "$choice" in
            1) show_placeholder "Scan" ;;
            2) show_placeholder "Help" ;;
            3) show_placeholder "About" ;;
            x|X) graceful_exit ;;
            *)
                log_error "Invalid choice: $choice"
                sleep 1
                ;;
        esac
    done
}

main_menu
