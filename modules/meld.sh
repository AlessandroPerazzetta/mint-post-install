#!/usr/bin/env bash
# Module: meld
# DESC: meld
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_meld() {
    printf "${YELLOW}Installing meld...\n${NC}"
    sudo apt-get -y install meld
}
