#!/usr/bin/env bash
# Module: bruno
# DESC: bruno
# DEFAULT: on
# ORDER: 360
# Called by install-packages.sh orchestrator

install_bruno() {
    printf "${YELLOW}Installing Bruno The Git-native API client...\n${NC}"
    curl -s https://api.github.com/repos/usebruno/bruno/releases/latest |grep "browser_download_url.*amd64_linux.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /tmp/bruno-latest-amd64_linux.deb
    sudo dpkg -i /tmp/bruno-latest-amd64_linux.deb
}
