#!/usr/bin/env bash
# Module: cinnamon_spices
# DESC: Cinnamon spices
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_cinnamon_spices() {
    printf "${YELLOW}Installing cinnamon applets and extensions...\n${NC}"
    # cinnamon applet installer
    cd ~/.local/share/cinnamon/applets/

    printf "${LCYAN}- Applet QRedShift:\n${NC}"
    # QRedShift
    # This version is currently outdated and will no longer receive updates from the original author.
    # Using author official repository
    curl https://github.com/raphaelquintao/QRedshiftCinnamon/raw/master/install.sh -sSfL | bash

    printf "${LCYAN}- Applet Bash Sensors:\n${NC}"
    # Bash Sensors
    curl -O https://cinnamon-spices.linuxmint.com/files/applets/bash-sensors@pkkk.zip && unzip bash-sensors@pkkk.zip && rm -rf bash-sensors@pkkk.zip
    sudo curl -fsSLo /usr/local/sbin/get-temps.sh https://raw.githubusercontent.com/AlessandroPerazzetta/cinnamon-applet-bash_sensors/main/get-temps.sh
    sudo chmod +x /usr/local/sbin/get-temps.sh

    printf "${LCYAN}- Applet Sensors Monitor:\n${NC}"
    # Sensors Monitor
    curl -O https://cinnamon-spices.linuxmint.com/files/applets/Sensors@claudiux.zip && unzip Sensors@claudiux.zip && rm -rf Sensors@claudiux.zip

    # cinnamon extensions installer
    cd ~/.local/share/cinnamon/extensions/

    printf "${LCYAN}- Applet Extension Back to Monitor:\n${NC}"
    # Back to Monitor
    curl -O https://cinnamon-spices.linuxmint.com/files/extensions/back-to-monitor@nathan818fr.zip && unzip back-to-monitor@nathan818fr.zip && rm -rf back-to-monitor@nathan818fr.zip

    printf "${LCYAN}- Applet Extension Cinnamon Dynamic Wallpaper:\n${NC}"
    # Cinnamon Dynamic Wallpaper
    curl -O https://cinnamon-spices.linuxmint.com/files/extensions/cinnamon-dynamic-wallpaper@TobiZog.zip && unzip cinnamon-dynamic-wallpaper@TobiZog.zip && rm -rf innamon-dynamic-wallpaper@TobiZog.zip

    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Apply settings for spices using dconf or from applet/extension settings.\n\n"
    printf "\tExample:\n"
    printf "\t- dump: dconf dump: 'dconf dump / > dconf-root.conf'\n"
    printf "\t- load: dconf load: 'dconf load / < dconf-root.conf'\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    read -n 1 -s -r -p "Press any key to continue"
    sleep 3
    printf "\n${NC}"
}
