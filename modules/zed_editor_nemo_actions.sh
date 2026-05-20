#!/usr/bin/env bash
# Module: zed_editor_nemo_actions
# DESC: Zed editor nemo actions
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_zed_editor_nemo_actions() {
    printf "${YELLOW}Installing nemo action for zed...\n${NC}"
    mkdir -p ~/.local/share/nemo/actions/
    bash -c "echo -e '[Nemo Action]\nActive=true\nName=Zed here\nComment=Launch Zed on this folder\nExec=/opt/zed-stable/libexec/zed-editor %U\nIcon-Name=zim\nSelection=none\nExtensions=any\nQuote=double\nDependencies=/opt/zed-stable/libexec/zed-editor\n' > ~/.local/share/nemo/actions/zed.nemo_action"
}
