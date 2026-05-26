#!/usr/bin/env bash
# Module: vim
# DESC: vim
# DEFAULT: off
# ORDER: 110
# Called by install-packages.sh orchestrator

install_vim() {
    printf "${YELLOW}Installing vim...\n${NC}"
    sudo apt-get -y install vim
}
