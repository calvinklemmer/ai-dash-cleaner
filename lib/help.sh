#!/usr/bin/env bash
#
# lib/help.sh
# Help screen for AI Dash Cleaner.
# Expects PROJECT_ROOT to already be set and lib/colors.sh + lib/globals.sh
# to already be sourced (for CYAN/NC and print_banner).

show_help() {
    print_banner
    echo "v0.1.0-dev"
    echo
    echo -e "${CYAN}Help:${NC}"
    echo "Scan  - scan a folder and replace AI dashes with a regular hyphen"
    echo "Help  - this screen"
    echo "About - version and license info"
    echo "Exit  - quit the program"
    echo
    echo
    read -rp "Press ENTER to return.." _
}
