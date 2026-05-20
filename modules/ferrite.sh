#!/usr/bin/env bash
# Module: ferrite
# DESC: Ferrite editor
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_ferrite() {
    printf "${YELLOW}Installing Ferrite editor...\n${NC}"
    curl -s https://api.github.com/repos/OlaProeis/Ferrite/releases/latest | grep -oP '"browser_download_url": "\K[^"]+\.deb' | xargs curl -LO -o /tmp/ferrite-editor_amd64.deb
    sudo dpkg -i /tmp/ferrite-editor_amd64.deb
}
