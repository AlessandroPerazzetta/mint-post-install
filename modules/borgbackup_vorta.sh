#!/usr/bin/env bash
# Module: borgbackup_vorta
# Called by install-packages.sh orchestrator

install_borgbackup_vorta() {
    printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
    sudo apt-get -y install borgbackup
    sudo apt-get -y install libxcb-cursor0
    sudo apt-get -y install python3-pyfuse3
    # sudo -H pip3 install vorta
    # sudo apt-get -y install vorta
    sudo pip3 install vorta --break-system-packages
}
