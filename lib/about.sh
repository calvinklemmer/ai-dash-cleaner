#!/usr/bin/env bash
#
# lib/about.sh
# About screen for AI Dash Cleaner.
# Expects PROJECT_ROOT to already be set and lib/colors.sh + lib/globals.sh
# to already be sourced (for CYAN/NC and print_banner).

show_about() {
    print_banner
    echo
    echo -e "${CYAN}About${NC}"
    echo "Detects and removes AI-style dashes (en dash - U+2013, em dash - U+2014)"
    echo "from text files and Word documents, replacing them with a regular hyphen."
    echo
    echo
    read -rp "Press ENTER to return.." _
}
