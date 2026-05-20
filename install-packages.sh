#!/bin/bash

# ---------------------------------------------------------------------------
# Context detection: local clone vs pipe (curl | bash)
# ---------------------------------------------------------------------------
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(mktemp -d /tmp/mint-post-install.XXXXXX)"
    REMOTE_BRANCH="${MINT_BRANCH:-main}"
    REMOTE_BASE="https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/${REMOTE_BRANCH}"
    REMOTE_API_BASE="https://api.github.com/repos/AlessandroPerazzetta/mint-post-install"
    _remote_mode=true
fi
LIB_DIR="${SCRIPT_DIR}/lib"
MODULES_DIR="${SCRIPT_DIR}/modules"

if [[ "${_remote_mode:-false}" == "true" ]]; then
    mkdir -p "${LIB_DIR}" "${MODULES_DIR}"
    for f in colors.sh helpers.sh; do
        curl -fsSLo "${LIB_DIR}/${f}" "${REMOTE_BASE}/lib/${f}"
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
# Entries can be "package" (binary==package) or "binary:package" when they differ
commands_to_check_exist=("build-essential" "apt-transport-https" "curl" "sshfs" "git" "jq" "pigz" "pbzip2" "pxz" "zip" "unzip" "rg:ripgrep")
for entry in "${commands_to_check_exist[@]}"; do
    if [[ "$entry" == *:* ]]; then
        cmd="${entry%%:*}"
        pkg="${entry##*:}"
    else
        cmd="$entry"
        pkg="$entry"
    fi
    # if ! command_exists $cmd; then
    if command_exists "$cmd" && command_exists_apt "$pkg"; then
        printf "${LGREEN}Command ${pkg} is already installed.\n${NC}"
    else
        printf "${LCYAN}Command ${pkg} not found. Installing... \n${NC}"
        sudo apt-get -y install "$pkg"
        printf "\n${NC}"
    fi
done
sleep 1

# Remote module discovery — deferred until curl and jq are guaranteed available
if [[ "${_remote_mode:-false}" == "true" ]]; then
    _api_url="${REMOTE_API_BASE}/contents/modules?ref=${REMOTE_BRANCH}"
    _module_keys="$(curl -fsSL "${_api_url}" \
        | jq -r '.[] | select(.name | endswith(".sh")) | .name[:-3]')"
    if [[ -z "$_module_keys" ]]; then
        printf "${RED}ERROR: Failed to fetch module list from %s\n${NC}" "${_api_url}" >&2
        exit 1
    fi
    while IFS= read -r key; do
        curl -fsSLo "${MODULES_DIR}/${key}.sh" "${REMOTE_BASE}/modules/${key}.sh"
    done <<< "$_module_keys"
fi

read dialog <<< "$(which whiptail dialog 2> /dev/null)"
[[ "$dialog" ]] || {
    printf "${LRED}Neither whiptail nor dialog found\n${NC}"
    exit 1
}

# Build ALL_OPTIONS dynamically from module metadata (# DESC / # DEFAULT headers)
ALL_OPTIONS=()
for _mod_file in "${MODULES_DIR}"/*.sh; do
    [[ -f "$_mod_file" ]] || continue
    _key="$(basename "${_mod_file}" .sh)"
    _desc="$(grep -m1 '^# DESC:' "${_mod_file}" | sed 's/^# DESC:[[:space:]]*//')"
    _default="$(grep -m1 '^# DEFAULT:' "${_mod_file}" | sed 's/^# DEFAULT:[[:space:]]*//')"
    [[ -z "$_desc" ]] && _desc="$_key"
    [[ "$_default" != "on" && "$_default" != "off" ]] && _default="off"
    ALL_OPTIONS+=("${_key}|${_desc}|${_default}")
done

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
