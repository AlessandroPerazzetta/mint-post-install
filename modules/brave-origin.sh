#!/usr/bin/env bash
# Module: brave-origin
# Called by install-packages.sh orchestrator

install_brave_origin() {
    printf "${YELLOW}Installing brave-origin-browser...\n${NC}"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-nightly-archive-keyring.gpg https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-nightly.sources https://brave-browser-apt-nightly.s3.brave.com/brave-browser.sources
    sudo apt-get update
    sudo apt-get -y install brave-origin-nightly
}
