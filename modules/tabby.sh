#!/usr/bin/env bash
# Module: tabby
# DESC: tabby
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_tabby() {
    printf "${YELLOW}Installing tabby...\n${NC}"
    curl -s https://api.github.com/repos/Eugeny/tabby/releases/latest |grep "browser_download_url.*linux-x64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /tmp/tabby-latest-linux-x64.deb
    sudo dpkg -i /tmp/tabby-latest-linux-x64.deb
}
