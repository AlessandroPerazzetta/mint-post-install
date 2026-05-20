#!/usr/bin/env bash
# Module: dbgate
# Called by install-packages.sh orchestrator

install_dbgate() {
    printf "${YELLOW}Installing dbgate...\n${NC}"
    curl -s https://api.github.com/repos/dbgate/dbgate/releases/latest |grep "browser_download_url.*linux_amd64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /tmp/dbgate-latest-linux_amd64.deb
    sudo dpkg -i /tmp/dbgate-latest-linux_amd64.deb
}
