#!/usr/bin/env bash
# Module: vim_res
# DESC: vim resources
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_vim_res() {
    printf "${YELLOW}Installing vim resources...\n${NC}"
    printf "${YELLOW}Installing vim resources from git sparse checkout...\n${NC}"
    mkdir -p /tmp/dotfiles-vim.git
    cd /tmp/dotfiles-vim.git
    git init
    git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
    git sparse-checkout set vim
    git pull origin main
    mv vim/vimrc ~/.vimrc
    cd -
    rm -rf /tmp/dotfiles-vim.git
}
