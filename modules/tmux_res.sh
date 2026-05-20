#!/usr/bin/env bash
# Module: tmux_res
# DESC: tmux resources
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_tmux_res() {
    printf "${YELLOW}Installing tmux resources...\n${NC}"
    #curl -fsSLo ~/.tmux.conf https://raw.githubusercontent.com/AlessandroPerazzetta/dotfiles/main/.tmux.conf

    printf "${YELLOW}Installing tmux resources from git sparse checkout...\n${NC}"
    mkdir -p /tmp/dotfiles-tmux.git
    cd /tmp/dotfiles-tmux.git
    git init
    git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
    git sparse-checkout set tmux
    git pull origin main
    mv tmux ~/.config/
    cd -

    printf "${YELLOW}Fix system binding to run tmux on all terminals...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Backing up /usr/share/applications/kitty.desktop to /usr/share/applications/kitty.desktop.ORI : \n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    sudo cp /usr/share/applications/kitty.desktop /usr/share/applications/kitty.desktop.ORI

    ##### NOT needed due to global gsettings config #####
    # sudo sed -i -e "s/Exec=kitty/Exec=kitty -e tmux/g" /usr/share/applications/kitty.desktop

    ##### Original GNOME command #####
    # gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/kitty'
    # gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e tmux'

    ##### exec not working on cinnamon 21.3, need to create a bash to call full command #####
    ##### TOODO check on next cinnamon version #####
    # gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty -e tmux'
    ##### exec-arg not working on cinnamon, need to pass full command and args on exec #####
    # gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '-e tmux'

    # sudo bash -c "echo -e '' > /usr/bin/kitty-tmux"
    # sudo chmod +x /usr/bin/kitty-tmux
    # gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty-tmux'

    # release_number="$(cat /etc/issue | cut -d ' ' -f3|cut -f1 -d".")"
    # release_number="$(lsb_release -rs | cut -d. -f1|tr -d '\r\n')"

    if [[ ${RELEASE_NUMBER} -le 21 ]]; then
        printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
        printf "Writing kitty tmux wrapper and set as default terminal application v21 and prior...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        sudo bash -c "echo -e '' > /usr/bin/kitty-tmux"
        sudo chmod +x /usr/bin/kitty-tmux
        gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty-tmux'
    elif [[ ${RELEASE_NUMBER} -ge 22 ]]; then
        printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
        printf "Set kitty tmux gsettings as default terminal application v22 and later...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty -e tmux'
    else
        printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
        printf "Release number not recognized, skipping tmux wrapper/binding...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        sleep 5
    fi
}
