#!/usr/bin/env bash
# Module: rustconn
# DESC: Rust connection manager
# DEFAULT: on
# ORDER: 501
# Called by install-packages.sh orchestrator

install_rustconn() {
    printf "${YELLOW}Installing rustconn...\n${NC}"
    # Get current mint version
    MINT_VERSION=$(lsb_release -rs)
    # Get maajor version    MINT_MAJOR_VERSION=$(echo "$MINT_VERSION" | cut -d. -f1)
    MINT_MAJOR_VERSION=$(echo "$MINT_VERSION" | cut -d. -f1)
    # Get minor version    MINT_MINOR_VERSION=$(echo "$MINT_VERSION" | cut -d. -f2)
    MINT_MINOR_VERSION=$(echo "$MINT_VERSION" | cut -d. -f2)
    
    # Rustconn repositories refer to Ubuntu versions, so we need to map the mint version to the corresponding ubuntu version and enable the repository
    # - Ubuntu 25.04 LTS (Noble) <= Mint 22
    # - Ubuntu 26.04 LTS (Resolut) >= Mint 23

    # Version Matrix
    # Linux Mint Version,Mint Codename,Underlying Ubuntu Base,Ubuntu Codename
    # "Mint 23, 23.1, 23.2","Vanessa, Vera, Victoria"   ->  Ubuntu 26.04 LTS,Resolut
    # "Mint 22, 22.1, 22.2","Wilma, Xia, ..."   ->  Ubuntu 24.04 LTS,Noble Numbat
    # "Mint 21, 21.1, 21.2, 21.3","Vanessa, Vera, Victoria, Virginia"   ->  Ubuntu 22.04 LTS,Jammy Jellyfish
    # "Mint 20, 20.1, 20.2, 20.3","Ulyana, Ulyssa, Uma, Una"    ->  Ubuntu 20.04 LTS,Focal Fossa
    # "Mint 19, 19.1, 19.2, 19.3","Tara, Tessa, Tina, Tricia"   ->  Ubuntu 18.04 LTS,Bionic Beaver
    # "Mint 17 to 17.3,"Qiana, Rebecca, Rafaela, Rosa"  ->  Ubuntu 14.04 LTS,Trusty Tahr

    if [[ "$MINT_MAJOR_VERSION" -eq 22 ]]; then
        # Enable the repository for Ubuntu 24.04 LTS (Noble)
        echo 'deb http://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_24.04/ /'   | sudo tee /etc/apt/sources.list.d/rustconn.list
        curl -fsSL https://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_24.04/Release.key   | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/rustconn.gpg > /dev/null
        sudo apt update && sudo apt install rustconn
    elif [[ "$MINT_MAJOR_VERSION" -eq 23 ]]; then
        # Enable the repository for Ubuntu 26.04 LTS (Resolut)
        echo 'deb http://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_26.04/ /'  | sudo tee /etc/apt/sources.list.d/rustconn.list
        curl -fsSL https://download.opensuse.org/repositories/home:/totoshko88:/rustconn/xUbuntu_26.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/rustconn.gpg > /dev/null
        sudo apt update && sudo apt install rustconn
    else
        printf "${RED}Unsupported Linux Mint version: $MINT_VERSION. Please install rustconn manually.${NC}\n"
        return
    fi
}
