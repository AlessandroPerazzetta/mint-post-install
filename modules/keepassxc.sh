#!/usr/bin/env bash
# Module: keepassxc
# DESC: KeePassXC
# DEFAULT: on
# ORDER: 540
# Called by install-packages.sh orchestrator

install_keepassxc() {
    printf "${YELLOW}Installing keepassxc...\n${NC}"
    sudo apt-add-repository -y ppa:phoerious/keepassxc
    sudo apt-get update
    sudo apt-get -y install keepassxc
}
