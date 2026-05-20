#!/usr/bin/env bash
# Module: kitty
# DESC: kitty
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_kitty() {
    printf "${YELLOW}Installing kitty...\n${NC}"
    sudo apt-get -y install kitty

    printf "${YELLOW}Set kitty as default terminal on cinnamon...\n${NC}"
    dconf write /org/cinnamon/desktop/applications/terminal/exec "'/usr/bin/kitty'"

    sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
}
