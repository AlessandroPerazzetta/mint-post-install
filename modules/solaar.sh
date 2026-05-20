#!/usr/bin/env bash
# Module: solaar
# Called by install-packages.sh orchestrator

install_solaar() {
    printf "${YELLOW}Installing solaar (Logitech mouse support)...\n${NC}"
    sudo add-apt-repository -y ppa:solaar-unifying/stable
    sudo apt update
    sudo apt-get -y install solaar
}
