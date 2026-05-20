#!/usr/bin/env bash
# Module: neovim
# Called by install-packages.sh orchestrator

install_neovim() {
    printf "${YELLOW}Installing neovim...\n${NC}"
    sudo apt-get -y install neovim
    printf "${YELLOW}Installing neovim resources...\n${NC}"
    mkdir -p ~/.config/nvim/
    curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim
    printf "${YELLOW}Set nvim as default editor...\n${NC}"
    sudo update-alternatives --set editor /usr/bin/nvim
    printf "${YELLOW}Remove others editor...\n${NC}"
    sudo apt-get -y remove nano ed
}
