#!/usr/bin/env bash
# Module: gedit_res
# DESC: Gedit theme resources
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_gedit_res() {
    printf "${YELLOW}Installing Gedit resources...\n${NC}"
    mkdir -p ~/.local/share/gedit/styles/
    curl -fsSLo ~/.local/share/gedit/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
}
