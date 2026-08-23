#!/usr/bin/env bash
#
# lib/common.sh
# Shared logging helpers, used by menu.sh and (later) the scan module.
# Expects PROJECT_ROOT to already be set and lib/colors.sh to already be sourced.

log_info() {
    echo -e "${CYAN}[*]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo "";echo -e "${RED}[ERROR]${NC} $1" >&2
}
