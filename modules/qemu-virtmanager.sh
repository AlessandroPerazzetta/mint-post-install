#!/usr/bin/env bash
# Module: qemu-virtmanager
# DESC: QEMU and Virt-Manager
# DEFAULT: off
# ORDER: 551
# Called by install-packages.sh orchestrator

install_qemu_virtmanager() {
    printf "${YELLOW}Installing QEMU and Virt-Manager...\n${NC}"
    # Step 1: Install the Packages
    printf "${CYAN}Updating package lists and installing packages...\n${NC}"
    sudo apt-get update
    sudo apt-get -y install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

    # Step 2: Enable and Start the Service
    printf "${CYAN}Enabling and starting libvirtd service...\n${NC}"
    sudo systemctl enable --now libvirtd

    # Step 3: Configure User Permissions
    printf "${CYAN}Configuring user (${CURRENT_USER}) permissions...\n${NC}"
    sudo usermod -aG libvirt $CURRENT_USER
    sudo usermod -aG kvm $CURRENT_USER
}
