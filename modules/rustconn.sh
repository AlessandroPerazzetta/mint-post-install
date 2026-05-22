#!/usr/bin/env bash
# Module: rustconn
# DESC: Rust connection manager
# DEFAULT: on
# ORDER: 501
# Called by install-packages.sh orchestrator

install_rustconn() {
    printf "${YELLOW}Installing rustconn...\n${NC}"
    # Rustconn repositories refer to Ubuntu versions, so we need to map the mint version to the corresponding ubuntu version and enable the repository
    # - Ubuntu 25.04 LTS (Noble) <= Mint 22
    # - Ubuntu 26.04 LTS (Resolut) >= Mint 23

    if [[ ${RELEASE_NUMBER} -eq 22 ]]; then
        # Enable the repository for Ubuntu 24.04 LTS (Noble)
        echo 'deb http://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_24.04/ /'   | sudo tee /etc/apt/sources.list.d/rustconn.list
        curl -fsSL https://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_24.04/Release.key   | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/rustconn.gpg > /dev/null
        sudo apt update && sudo apt-get -y install rustconn
    elif [[ ${RELEASE_NUMBER} -eq 23 ]]; then
        # Enable the repository for Ubuntu 26.04 LTS (Resolut)
        echo 'deb http://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_26.04/ /'  | sudo tee /etc/apt/sources.list.d/rustconn.list
        curl -fsSL https://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_26.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/rustconn.gpg > /dev/null
        sudo apt update && sudo apt-get -y install rustconn
    else
        printf "${RED}Unsupported Linux Mint version: ${RELEASE_NUMBER}. Please install rustconn manually.${NC}\n"
        return
    fi
}
