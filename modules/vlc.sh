#!/usr/bin/env bash
# Module: vlc
# DESC: VLC
# DEFAULT: on
# ORDER: 510
# Called by install-packages.sh orchestrator

install_vlc() {
    printf "${YELLOW}Installing vlc...\n${NC}"
    sudo apt-get -y install vlc

    printf "${YELLOW}Installing vlc media library...\n${NC}"
    mkdir -p ~/.local/share/vlc/
    curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
}
