#!/usr/bin/env bash
# Module: sys_serial
# DESC: System serial permission
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_sys_serial() {
    printf "${YELLOW}Installing system permissions to allow user open Serial...\n${NC}"
    grep -Ei "^dialout" /etc/group;
    if [ $? -eq 0 ]; then
        printf "${YELLOW}Dialout Group Exists add current user...\n${NC}"
        if id -nG "$CURRENT_USER" | grep -qw "dialout"; then
            printf "${YELLOW}User is already in dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
        else
            printf "${YELLOW}Add user to dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
            sudo usermod -a -G dialout $CURRENT_USER
        fi
    else
        echo ""
        printf "${RED}Dialout Group Not Exists can't add current user...\n${NC}"
    fi
}
