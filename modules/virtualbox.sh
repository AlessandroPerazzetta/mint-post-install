#!/usr/bin/env bash
# Module: virtualbox
# Called by install-packages.sh orchestrator

install_virtualbox() {
    printf "${YELLOW}Installing virtualbox...\n${NC}"
    curl -fSsL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null
    # echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    # Fixed codename
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    # os-release codename (get distro release codename, ex on mint return virginia)
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$VERSION_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    # lsb-release codename (get general release codename, ex on mint return jammy, that is ubuntu release codename base)
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/upstream-release/lsb-release && echo "$DISTRIB_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    # os-release ubuntu codename (get distro release codename, ex on mint return jammy)
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$UBUNTU_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    sudo apt-get update
    # sudo apt-get -y install virtualbox
    sudo apt-get -y install virtualbox-7.2
    sudo adduser $CURRENT_USER vboxusers
    sudo adduser $CURRENT_USER disk

    # printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    # printf "Please download virtualbox extension pack from here: \n"
    # printf "https://www.virtualbox.org/wiki/Downloads\n"
    # printf "and install manually from VirtualBox under File > Preferences > Extensions\n"
    # printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    # read -n 1 -s -r -p "Press any key to continue"
    # printf "\n${NC}"

    printf "${YELLOW}Installing virtualbox extension...\n${NC}"
    curl -O https://download.virtualbox.org/virtualbox/$(vboxmanage -v | cut -dr -f1)/Oracle_VirtualBox_Extension_Pack-$(vboxmanage -v | cut -dr -f1).vbox-extpack
    echo "y" | sudo vboxmanage extpack install Oracle_VirtualBox_Extension_Pack-$(vboxmanage -v | cut -dr -f1).vbox-extpack
}
