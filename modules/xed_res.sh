#!/usr/bin/env bash
# Module: xed_res
# DESC: Xed theme resources
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_xed_res() {
    printf "${YELLOW}Installing Xed resources...\n${NC}"
    mkdir -p ~/.local/share/xed/styles/
    curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
}
