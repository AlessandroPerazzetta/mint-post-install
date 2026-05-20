#!/usr/bin/env bash
# Module: vim
# DESC: vim
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_vim() {
    printf "${YELLOW}Installing vim...\n${NC}"
    sudo apt-get -y install vim
}
