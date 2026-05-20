#!/usr/bin/env bash
# Module: spotube
# DESC: Spotube
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_spotube() {
    printf "${YELLOW}Installing spotube...\n${NC}"
    curl -s https://api.github.com/repos/KRTirtho/spotube/releases/latest |grep "browser_download_url.*linux-x86_64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 curl -L -o /tmp/spotube-latest-linux-x86_64.deb
    sudo dpkg -i /tmp/spotube-latest-linux-x86_64.deb
}
