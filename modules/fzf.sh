#!/usr/bin/env bash
# Module: fzf
# DESC: fzf - A command-line fuzzy finder
# DEFAULT: on
# ORDER: 500
# Called by install-packages.sh orchestrator

install_fzf() {
    printf "${YELLOW}Installing fzf...\n${NC}"
    sudo apt-get update
    sudo apt-get install -y fzf
}
