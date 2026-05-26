#!/usr/bin/env bash
# Module: sys_tweaks
# DESC: System tweaks
# DEFAULT: on
# ORDER: 20
# Called by install-packages.sh orchestrator

install_sys_tweaks() {
    printf "${YELLOW}System tweaks...\n${NC}"
    # ----> OUT
    # # Allow any user to mount umount without requiring user authentication.
    # ALL ALL = NOPASSWD:/usr/bin/mount
    # ALL ALL = NOPASSWD:/usr/bin/umount
    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Allow any user to mount umount without requiring user authentication.\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    read -n 1 -s -r -p "Press any key to continue"
    sleep 3
    printf "\n${NC}"
    sudo bash -c "echo -e '# Allow any user to mount umount without requiring user authentication.\nALL ALL = NOPASSWD:/usr/bin/mount\nALL ALL = NOPASSWD:/usr/bin/umount' >> /etc/sudoers.d/mountumount"
}
