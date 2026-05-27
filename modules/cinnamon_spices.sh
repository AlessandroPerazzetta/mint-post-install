#!/usr/bin/env bash
# Module: cinnamon_spices
# DESC: Cinnamon spices
# DEFAULT: on
# ORDER: 700
# Called by install-packages.sh orchestrator

install_cinnamon_spices() {
    # Detect if cinnamon command exists to determine if cinnamon desktop environment is installed
    if command_exists cinnamon; then
        printf "${YELLOW}Installing cinnamon applets and extensions...\n${NC}"
        # cinnamon applet installer
        mkdir -p ~/.local/share/cinnamon/applets
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

        # Detect cinnamon version and if >= 6.6.0 ask user to install classic menu. 
        #Detect cinnamon version using cinnamon --version (if command exists) and extract version number using regex    
        cinnamon_version=$(cinnamon --version | grep -oP '\d+\.\d+\.\d+')
        if [[ $(printf '%s\n' "6.6.0" "$cinnamon_version" | sort -V -c) ]]; then
            # Ask user if they want to install the classic menu applet extension, yes as default if they just press enter
            read -n 1 -s -r -p "Cinnamon version ${cinnamon_version} detected. Do you want to install the Classic Menu applet extension? [Y/n] " response
            printf "\n"
            if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then                
                printf "${LCYAN}- Applet Extension Classic Menu:\n${NC}"
                # Define applet variables
                APPLET_UUID="classic-menu@cinnamon.org"
                TARGET_DIR="$HOME/.local/share/cinnamon/applets/$APPLET_UUID"
                DOWNLOAD_URL="https://cinnamon-spices.linuxmint.com/files/applets/$APPLET_UUID.zip"
                TEMP_ZIP="/tmp/$APPLET_UUID.zip"
                # 1. Create target directory if it doesn't exist
                mkdir -p "$HOME/.local/share/cinnamon/applets"
                # 2. Download the applet zip file
                printf "${LPURPLE}- Downloading applet from Cinnamon Spices...\n${NC}"
                curl -sSL "$DOWNLOAD_URL" -o "$TEMP_ZIP"
                # 3. Extract the applet
                printf "${LPURPLE}- Extracting files...\n${NC}"
                # Remove old folder if it exists to prevent conflicts
                rm -rf "$TARGET_DIR"
                unzip -q "$TEMP_ZIP" -d "$HOME/.local/share/cinnamon/applets"
                # 4. Clean up temporary zip file
                rm "$TEMP_ZIP"
                # 5. Enable the applet in Cinnamon's settings backend
                printf "${LPURPLE}- Activating applet on the panel...\n${NC}"
                # This gsettings command appends the applet to your current bottom panel configuration
                CURRENT_APPLETS=$(gsettings get org.cinnamon enabled-applets)

                # Check if the applet is already enabled to prevent duplicates
                if [[ "$CURRENT_APPLETS" != *"$APPLET_UUID"* ]]; then
                    # Appends the new applet to panel 0, left zone (position 1)
                    NEW_APPLETS=$(echo "$CURRENT_APPLETS" | sed "s/\]$/, 'panelId': 0, 'order': 1, 'applet-id': 99, 'uuid': '$APPLET_UUID'}]/")
                    gsettings set org.cinnamon enabled-applets "$NEW_APPLETS"
                    printf "${LGREEN}- Applet enabled successfully!\n${NC}"
                else
                    printf "${LORANGE}- Applet is already active on your panel.\n${NC}"
                fi
            fi
        else
            printf "${LCYAN}- Skipping Classic Menu extension as it requires Cinnamon 6.6.0 or higher. Detected version: ${cinnamon_version}\n${NC}"
        fi

        printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
        printf "Apply settings for spices using dconf or from applet/extension settings.\n\n"
        printf "\tExample:\n"
        printf "\t- dump: dconf dump: 'dconf dump / > dconf-root.conf'\n"
        printf "\t- load: dconf load: 'dconf load / < dconf-root.conf'\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        read -n 1 -s -r -p "Press any key to continue"
        sleep 3
        printf "\n${NC}"
    else
        printf "${LRED}Cinnamon desktop environment not detected. Skipping cinnamon spices installation.\n${NC}"
    fi
}
