#!/usr/bin/env bash
# Module: fastfetch
# DESC: fastfetch
# DEFAULT: on
# ORDER: 590
# Called by install-packages.sh orchestrator

install_fastfetch() {
    printf "${YELLOW}Installing fastfetch...\n${NC}"
    curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest |grep "browser_download_url.*linux-amd64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /tmp/fastfetch-latest-linux-amd64.deb
    sudo dpkg -i /tmp/fastfetch-latest-linux-amd64.deb
}
