#!/usr/bin/env bash
# Module: grpcurl
# DESC: grpcurl
# DEFAULT: on
# ORDER: 330
# Called by install-packages.sh orchestrator

install_grpcurl() {
    printf "${YELLOW}Installing grpcurl...\n${NC}"
    curl -s https://api.github.com/repos/fullstorydev/grpcurl/releases/latest |grep "browser_download_url.*linux_amd64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 curl -L -o /tmp/grpcurl_latest_linux_amd64.deb
    sudo dpkg -i /tmp/grpcurl_latest_linux_amd64.deb
}
