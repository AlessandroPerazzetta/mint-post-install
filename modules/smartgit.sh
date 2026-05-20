#!/usr/bin/env bash
# Module: smartgit
# DESC: SmartGit
# DEFAULT: off
# ORDER: 320
# Called by install-packages.sh orchestrator

install_smartgit() {
    printf "${YELLOW}Installing smartgit...\n${NC}"
    sudo curl -fsSLo /tmp/smartgit-23_1_2.deb https://www.syntevo.com/downloads/smartgit/smartgit-23_1_2.deb
    sudo dpkg -i /tmp/smartgit-23_1_2.deb
}
