#!/usr/bin/env bash
#
# lib/globals.sh
# Banner and the "not built yet" screen for menu items that aren't wired
# to real functionality yet.

# Single source of truth for the version string - shown in the banner on
# every screen, so it never needs to be repeated per screen.
readonly APP_VERSION="v0.1.0-dev"

print_banner() {
    clear
    local title="AI DASH CLEANER"
    local width=29
    local pad_total=$(( width - ${#title} ))
    local pad_left=$(( pad_total / 2 ))
    local pad_right=$(( pad_total - pad_left ))
    local version_pad=$(( width - ${#APP_VERSION} - 1 ))

    # No leading/trailing blank line here on purpose - callers decide their
    # own spacing after the banner (see menu.sh vs lib/about.sh).
    printf '%b┌%s┐\n' "$CYAN" "$(printf '─%.0s' $(seq 1 "$width"))"
    printf '│%*s%s%*s│\n' "$pad_left" '' "$title" "$pad_right" ''
    printf '│%*s%s │\n' "$version_pad" '' "$APP_VERSION"
    printf '└%s┘%b\n' "$(printf '─%.0s' $(seq 1 "$width"))" "$NC"
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
