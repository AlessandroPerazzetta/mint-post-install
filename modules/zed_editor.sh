#!/usr/bin/env bash
# Module: zed_editor
# DESC: Zed editor
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_zed_editor() {
    printf "${YELLOW}Installing Zed editor...\n${NC}"

    installation_path="/opt"
    channel="stable"
    platform="$(uname -s)"
    arch="$(uname -m)"
    if [ "$platform" = "Darwin" ]; then
        platform="macos"
    elif [ "$platform" = "Linux" ]; then
        platform="linux"
    else
        printf "${RED}Unsupported platform $platform\n${NC}"
        exit 1
    fi

    case "$platform-$arch" in
        macos-arm64* | linux-arm64* | linux-armhf | linux-aarch64)
            arch="aarch64"
            ;;
        macos-x86* | linux-x86* | linux-i686*)
            arch="x86_64"
            ;;
        *)
            printf "${RED}Unsupported platform or architecture\n${NC}"
            exit 1
            ;;
    esac

    printf "${LCYAN}* Downloading Zed ($channel) for $platform-$arch to $installation_path/zed-${channel}\n${NC}"
    tarball="zed-${platform}-${arch}.tar.gz"
    url="https://zed.dev/api/releases/${channel}/latest/${tarball}"
    curl -fL "$url" -o "/tmp/$tarball"

    # Ensure $installation_path/zed-${channel} exists, try as user first, then with sudo if needed
    printf "${LCYAN}> Ensuring $installation_path/zed-${channel} exists.\n${NC}"
    mkdir -p "$installation_path/zed-${channel}" || {
        printf "${LRED} °°° Failed to create $installation_path/zed-${channel}. Trying with sudo."
        sudo mkdir -p "$installation_path/zed-${channel}" || {
            printf "${RED} °°° Failed to create $installation_path/zed-${channel} even with sudo. Exiting.\n${NC}"
            exit 1
        }
    }

    # Check if we have write permissions
    if [ ! -w "$installation_path/zed-${channel}" ]; then
        printf "${LYELLOW}* No write permissions for $installation_path/zed-${channel}. Trying to change ownership with sudo.\n${NC}"
        sudo chown -R "$(whoami)":"$(whoami)" "$installation_path/zed-${channel}" || {
            printf "${RED} °°° Failed to change ownership of $installation_path/zed-${channel}. Exiting.\n${NC}"
            exit 1
        }
    fi

    # Extract tarball to installation_path/zed-${channel} getting rid of the top-level directory
    printf "${LCYAN} * Extracting Zed to $installation_path/zed-${channel}...\n${NC}"
    tar -xzf "/tmp/$tarball" -C "$installation_path/zed-${channel}" --strip-components=1

    printf "${LCYAN}--------------------------------------------------------------------------------\n${LGREEN}"
    printf "Zed has been installed to $installation_path/zed-${channel}\n"
    printf "To run Zed from your terminal, add $installation_path/zed-${channel}/bin to your PATH\n"
    printf "For example, you can add the following line to your shell profile:\n"
    printf 'export PATH="$HOME/.local/bin:$PATH"\n'
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"

    # Install .desktop file and icons for desktop integration
    if [ "$platform" = "linux" ]; then
        if [ -n "${XDG_DATA_HOME:-}" ]; then
            data_home="$XDG_DATA_HOME"
        else
            data_home="$HOME/.local/share"
        fi
        cp "$installation_path/zed-${channel}/share/applications/zed.desktop" "$data_home/applications/dev.zed.Zed.desktop"
        sed -i "s|Icon=zed|Icon=$installation_path/zed-${channel}/share/icons/hicolor/512x512/apps/zed.png|g" "$data_home/applications/dev.zed.Zed.desktop"
        sed -i "s|Exec=zed|Exec=$installation_path/zed-${channel}/libexec/zed-editor|g" "$data_home/applications/dev.zed.Zed.desktop"
    fi
}
