#!/usr/bin/env bash
# Module: tmux
# DESC: tmux
# DEFAULT: on
# ORDER: 510
# Called by install-packages.sh orchestrator

install_tmux() {
    printf "${YELLOW}Installing tmux...\n${NC}"
    sudo apt-get -y install tmux
}
