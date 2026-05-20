#!/bin/bash

# ---------------------------------------------------------------------------
# Context detection: local clone vs pipe (curl | bash)
# ---------------------------------------------------------------------------
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(mktemp -d /tmp/mint-post-install.XXXXXX)"
    REMOTE_BASE="https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main"
    _remote_mode=true
fi
LIB_DIR="${SCRIPT_DIR}/lib"
MODULES_DIR="${SCRIPT_DIR}/modules"

if [[ "${_remote_mode:-false}" == "true" ]]; then
    mkdir -p "${LIB_DIR}" "${MODULES_DIR}"
    for f in colors.sh helpers.sh; do
        curl -fsSLo "${LIB_DIR}/${f}" "${REMOTE_BASE}/lib/${f}"
    done
    for key in personal_res sys_serial xed_res gedit_res sys_tweaks sys_utils \
                cinnamon_spices nemo_actions vim vim_res neovim filezilla meld \
                lazygit vlc kitty kitty_res kitty_libgl_fix alacritty alacritty_res \
                tmux tmux_res brave brave_ext brave-origin brave-origin_ext remmina \
                tabby tabby_libgl_fix vscodium vscodium_nemo_actions vscodium_ext \
                vscode vscode_nemo_actions vscode_ext zed_editor zed_editor_nemo_actions \
                grpcurl unison marktext dbeaver dbgate smartgit mqtt_explorer \
                bruno arduino_cli keepassxc qownnotes virtualbox kicad freecad \
                telegram rust py_36 py_38 py_dev_pkgs latest_pip qt_stuff \
                imwheel bt_restart ssh_alive ssh_skip_hosts_check solaar \
                borgbackup_vorta spotify_spicetify spotube fancontrol fastfetch \
                nerd-fonts yt-dlp cliamp; do
        curl -fsSLo "${MODULES_DIR}/${key}.sh" "${REMOTE_BASE}/modules/${key}.sh"
    done
fi

# shellcheck source=lib/colors.sh
source "${LIB_DIR}/colors.sh"
# shellcheck source=lib/helpers.sh
source "${LIB_DIR}/helpers.sh"

CURRENT_USER=$(whoami)
RELEASE_NUMBER="$(lsb_release -rs | cut -d. -f1|tr -d '\r\n')"

printf "${YELLOW}------------------------------------------------------------------\n${NC}"
printf "${YELLOW}Starting ...\n${NC}"
printf "${YELLOW}------------------------------------------------------------------\n${NC}"

printf "${YELLOW}Updating system...\n${NC}"
sleep 1
sudo apt-get update
sudo apt-get -y upgrade

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1



# sudo apt-get -y install build-essential apt-transport-https curl sshfs dialog git
commands_to_check_exist=("build-essential" "apt-transport-https" "curl" "sshfs" "git" "jq" "pigz" "pbzip2" "pxz" "zip" "unzip" "ripgrep")
for cmd in "${commands_to_check_exist[@]}"; do
    # if ! command_exists $cmd; then
    if command_exists $cmd && command_exists_apt $cmd; then
        printf "${LGREEN}Command ${cmd} is already installed.\n${NC}"
    else
        printf "${LCYAN}Command ${cmd} not found. Installing... \n${NC}"
        sudo apt-get -y install $cmd
        printf "\n${NC}"
    fi
done
sleep 1

read dialog <<< "$(which whiptail dialog 2> /dev/null)"
[[ "$dialog" ]] || {
    printf "${LRED}Neither whiptail nor dialog found\n${NC}"
    exit 1
}

# Define all options and their default status in an array of "key|desc|default"
ALL_OPTIONS=(
    "personal_res|Personal resources|on"
    "sys_serial|System Serial permission|on"
    "xed_res|Xed theme resources|on"
    "gedit_res|Gedit theme resources|on"
    "sys_tweaks|System tewaks|on"
    "sys_utils|System utils|on"
    "cinnamon_spices|cinnamon_spices|on"
    "nemo_actions|nemo_actions|on"
    "vim|vim|off"
    "vim_res|vim_res|off"
    "neovim|neovim|on"
    "filezilla|filezilla|on"
    "meld|meld|on"
    "lazygit|lazygit|off"
    "vlc|vlc|on"
    "kitty|kitty|off"
    "kitty_res|kitty resources|off"
    "kitty_libgl_fix|kitty libgl fix|off"
    "alacritty|alacritty|on"
    "alacritty_res|alacritty resources|on"
    "tmux|tmux|on"
    "tmux_res|tmux resources|on"
    "brave|brave-browser|on"
    "brave_ext|brave-browser extensions|on"
    "brave-origin|brave-origin-browser|off"
    "brave-origin_ext|brave-origin-browser extensions|off"
    "remmina|remmina|on"
    "tabby|tabby|on"
    "tabby_libgl_fix|tabby libgl fix|off"
    "vscodium|vscodium|off"
    "vscodium_nemo_actions|vscodium_nemo_actions|off"
    "vscodium_ext|vscodium extensions|off"
    "vscode|vscode|on"
    "vscode_nemo_actions|vscode_nemo_actions|on"
    "vscode_ext|vscode extensions|on"
    "zed_editor|zed editor|on"
    "zed_editor_nemo_actions|zed editor nemo actions|on"
    "grpcurl|grpcurl|on"
    "unison|unison|on"
    "marktext|marktext|off"
    "ferrite|ferrite editor|on"
    "dbeaver|dbeaver|on"
    "dbgate|dbgate|on"
    "smartgit|smartgit|off"
    "mqtt_explorer|mqtt-explorer|on"
    "bruno|bruno|on"
    "arduino_cli|arduino-cli|on"
    "keepassxc|keepassxc|on"
    "qownnotes|qownnotes|on"
    "virtualbox|virtualbox|on"
    "kicad|kicad|off"
    "freecad|freecad|off"
    "telegram|telegram|on"
    "rust|rust|on"
    "py_36|python 3.6.15 (src install)|off"
    "py_38|python 3.8.19 (src install)|off"
    "py_dev_pkgs|python dev packages|on"
    "latest_pip|latest python pip|on"
    "qt_stuff|qtcreator + qt5|off"
    "imwheel|imwheel|off"
    "bt_restart|bt-restart|off"
    "ssh_alive|ssh-alive-settings|on"
    "ssh_skip_hosts_check|ssh-skip-hosts-check-settings|on"
    "solaar|solaar|on"
    "borgbackup_vorta|borgbackup + vorta gui|on"
    "spotify_spicetify|spotify + spicetify|off"
    "spotube|spotube|off"
    "fancontrol|fancontrol + config|on"
    "fastfetch|fastfetch|on"
    "nerd-fonts|nerd-fonts|on"
    "yt-dlp|yt-dlp|on"
    "cliamp|cli-amp|on"
)

# Parse arguments
ALL_OFF=false
for arg in "$@"; do
    [[ "$arg" == "--none" ]] && ALL_OFF=true
done

# Build options array for dialog/whiptail
options=()
for opt in "${ALL_OPTIONS[@]}"; do
    IFS='|' read -r key desc def <<< "$opt"
    if $ALL_OFF; then
        options+=("$key" "$desc" "off")
    else
        options+=("$key" "$desc" "$def")
    fi
done

cmd=("$dialog" --title "Automated packages installation" --backtitle "Mint Post Install" --separate-output --checklist "Select options:" 22 76 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]
then
    for choice in $choices
    do
        module_file="${MODULES_DIR}/${choice}.sh"
        if [[ -f "${module_file}" ]]; then
            # shellcheck source=/dev/null
            source "${module_file}"
            fn_name="install_${choice//-/_}"
            if declare -f "${fn_name}" > /dev/null; then
                "${fn_name}"
            else
                printf "${RED}Module ${choice}: function ${fn_name} not found.\n${NC}"
            fi
        else
            printf "${RED}Module not found: ${module_file}\n${NC}"
        fi
    done
else
        exit 0
fi
