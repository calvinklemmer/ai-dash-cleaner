#!/usr/bin/env bash
#
# lib/help.sh
# Help screen for AI Dash Cleaner.
# Expects PROJECT_ROOT to already be set and lib/colors.sh + lib/globals.sh
# to already be sourced (for CYAN/NC and print_banner).

show_help() {
    print_banner
    echo
    echo -e "${CYAN}Help${NC}"
    echo "This screen explains what each option in the menu does."
    echo
    echo "Scan  - find and replace AI dashes (en dash / em dash) with a hyphen"
    echo "Help  - this screen"
    echo "About - version and license info"
    echo "Exit  - quit the program nicely (Ctrl+C also works)"
    echo
    echo
    read -rp "Press ENTER to return.." _
}
