#!/usr/bin/env bash
# Module: kicad
# Called by install-packages.sh orchestrator

install_kicad() {
    printf "${YELLOW}Installing kicad...\n${NC}"
    sudo apt-add-repository -y ppa:kicad/kicad-9.0-releases
    sudo apt-get update
    sudo apt-get -y install --install-recommends kicad
}
