#!/usr/bin/env bash
# Module: vscode
# Called by install-packages.sh orchestrator

install_vscode() {
    printf "${YELLOW}Installing vscode...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
    printf "Writing vscode repository ...\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"

    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
    rm -f microsoft.gpg
    echo -e 'Types: deb\nURIs: https://packages.microsoft.com/repos/code\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg' | sudo tee /etc/apt/sources.list.d/vscode.sources

    sudo apt-get update && sudo apt-get -y install code
}
