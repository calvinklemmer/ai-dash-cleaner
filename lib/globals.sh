#!/usr/bin/env bash
#
# lib/globals.sh
# Banner and the "not built yet" screen for menu items that aren't wired
# to real functionality yet.

print_banner() {
    clear
    local title="AI DASH CLEANER"
    local width=29
    local pad_total=$(( width - ${#title} ))
    local pad_left=$(( pad_total / 2 ))
    local pad_right=$(( pad_total - pad_left ))

    echo -e "${CYAN}"
    printf '┌%s┐\n' "$(printf '─%.0s' $(seq 1 "$width"))"
    printf '│%*s%s%*s│\n' "$pad_left" '' "$title" "$pad_right" ''
    printf '└%s┘\n' "$(printf '─%.0s' $(seq 1 "$width"))"
    echo -e "${NC}"
}

# usage: show_placeholder "Scan"
show_placeholder() {
    local TITLE="$1"
    print_banner
    echo -e "${YELLOW}== $TITLE ==${NC}"
    echo
    echo "This feature isn't wired up yet - coming in a future step."
    echo
    read -rp "Press Enter to return to the menu..." _
}
