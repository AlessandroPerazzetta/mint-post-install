#!/usr/bin/env bash
# Module: tmux
# Called by install-packages.sh orchestrator

install_tmux() {
    printf "${YELLOW}Installing tmux...\n${NC}"
    sudo apt-get -y install tmux
}
