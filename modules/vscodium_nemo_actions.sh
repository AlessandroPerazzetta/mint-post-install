#!/usr/bin/env bash
# Module: vscodium_nemo_actions
# Called by install-packages.sh orchestrator

install_vscodium_nemo_actions() {
    printf "${YELLOW}Installing nemo action for vscodium...\n${NC}"
    mkdir -p ~/.local/share/nemo/actions/
    curl -fsSLo ~/.local/share/nemo/actions/codium.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action
}
