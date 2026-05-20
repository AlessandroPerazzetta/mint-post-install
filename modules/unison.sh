#!/usr/bin/env bash
# Module: unison
# DESC: Unison
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_unison() {
    printf "${YELLOW}Installing unison and unison-gtk...\n${NC}"
    sudo apt-get -y install unison unison-gtk
}
