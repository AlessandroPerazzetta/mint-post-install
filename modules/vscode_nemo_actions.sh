#!/usr/bin/env bash
# Module: vscode_nemo_actions
# Called by install-packages.sh orchestrator

install_vscode_nemo_actions() {
    printf "${YELLOW}Installing nemo action for vscode...\n${NC}"
    mkdir -p ~/.local/share/nemo/actions/
    bash -c "echo -e '[Nemo Action]\nActive=true\nName=Code here\nComment=Launch Code on this folder\nExec=code %P\nIcon-Name=vscode\nSelection=none\nExtensions=any;\nQuote=double\nDependencies=code;' > ~/.local/share/nemo/actions/code.nemo_action"
}
