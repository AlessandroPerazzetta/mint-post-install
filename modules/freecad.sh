#!/usr/bin/env bash
# Module: freecad
# Called by install-packages.sh orchestrator

install_freecad() {
    printf "${YELLOW}Installing freecad...\n${NC}"
    sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
    sudo apt-get update
    sudo apt-get -y install freecad
}
