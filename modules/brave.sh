#!/usr/bin/env bash
# Module: brave
# Called by install-packages.sh orchestrator

install_brave() {
    printf "${YELLOW}Installing brave-browser...\n${NC}"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
    sudo apt-get update
    sudo apt-get -y install brave-browser
}
