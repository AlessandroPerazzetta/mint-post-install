#!/usr/bin/env bash
# Module: nemo_actions
# DESC: nemo actions
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_nemo_actions() {
    printf "${YELLOW}Installing custom Nemo Actions...\n${NC}"
    mkdir -p ~/.local/share/nemo/actions/
    printf "${LCYAN}- Action: MKDTS\n${NC}"
    #bash -c "echo -e '# Custom action to create a dir with current timestamp\n[Nemo Action]\nName=MKDTS dir here\nComment=Create a dir with timestamp name\nExec=bash -c \"mkdir %F/$(date +%Y%m%d_%H%M)\"\nIcon-Name=inode-directory\nSelection=none\nExtensions=none\nDependencies=mkdir\nEscapeSpaces=true\nQuote=double' >> ~/.local/share/nemo/actions/mkdts.nemo_action"
    curl -fsSLo ~/.local/share/nemo/actions/mkdts.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main/nemo_actions/mkdts.nemo_action
}
