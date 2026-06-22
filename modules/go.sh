#!/usr/bin/env bash
# Module: go
# DESC: Go Language
# DEFAULT: off
# ORDER: 411
# Called by install-packages.sh orchestrator

install_go() {
    printf "${YELLOW}Installing Go...\n${NC}"

    GO_BIN_PATH=""
    INSTALL_TYPE=""

    # 1. Check for manual/tar.gz binary installation in /usr/local/go/bin
    if [ -x "/usr/local/go/bin/go" ]; then
        GO_BIN_PATH="/usr/local/go/bin/go"
        INSTALL_TYPE="tar.gz binary (/usr/local/go)"
    # 2. Check for system package installation (e.g., apt, yum) via system PATH
    elif command -v go &> /dev/null; then
        GO_BIN_PATH=$(command -v go)
        INSTALL_TYPE="system package manager"
    fi

    # 3. Handle version extraction based on detected path
    if [ -n "$GO_BIN_PATH" ]; then
        # Dynamically extract version string (e.g., "go1.22.1") using the found binary path
        GO_VERSION=$("$GO_BIN_PATH" version 2>/dev/null | awk '{print $3}')
        printf "${GREEN}Go is already installed via ${INSTALL_TYPE}.\n${NC}"
        printf "${CYAN}\tBinary Path: ${GO_BIN_PATH}\n${NC}"
        printf "${CYAN}\tVersion: ${GO_VERSION}\n${NC}"
    else
        printf "${RED}Go is not installed. Proceeding with installation...\n${NC}"
    fi

    # Fetch the Go downloads page and search for the latest linux-amd64 release archive
    LATEST_GO_RELEASE=$(curl -s https://go.dev/dl/ | \
        grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?\.linux-amd64\.tar\.gz' | \
        head -n 1)

    # Check if a release was found
    if [ -z "$LATEST_GO_RELEASE" ]; then
        printf "${RED}Error: Could not determine the latest Go release.\n${NC}"
        return
    fi

    printf "${GREEN}Latest Go Linux release package (from https://go.dev/dl/): ${LATEST_GO_RELEASE}\n${NC}"

    # Extract just the version number (e.g., "go1.22.1")
    VERSION_NUMBER=$(echo "$LATEST_GO_RELEASE" | sed 's/\.linux-amd64\.tar\.gz//')
    printf "${CYAN}\tVersion: ${VERSION_NUMBER}\n${NC}"

    # Check if the version installed is up to date or newer than the latest release
    if [ -n "$GO_VERSION" ]; then
        # sort -V -c returns 0 (true) if the input is sorted (meaning GO_VERSION >= VERSION_NUMBER)
        if printf '%s\n' "$VERSION_NUMBER" "$GO_VERSION" | sort -V -c &>/dev/null; then
            printf "${ORANGE}Installed Go version (${GO_VERSION}) is up to date or newer than the latest release (${VERSION_NUMBER}). Skipping installation.\n${NC}"
            return
        fi
    fi

    # Construct the full download URL
    DOWNLOAD_URL="https://go.dev/dl/$LATEST_GO_RELEASE"
    printf "${CYAN}Download URL: ${DOWNLOAD_URL}\n${NC}"

    # Download the latest Go release archive
    curl -L -o /tmp/"$LATEST_GO_RELEASE" "$DOWNLOAD_URL"

    # Extract the archive to /usr/local, removing any existing Go installation as sudo
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/"$LATEST_GO_RELEASE"
    
    # Clean up the downloaded archive
    rm -f /tmp/"$LATEST_GO_RELEASE"

    # Add Go to the PATH if it's not already there
    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.profile; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
        printf "${GREEN}Added Go to PATH in ~/.profile\n${NC}"
    else
        printf "${GREEN}Go is already in PATH configuration.\n${NC}"
    fi

    # Reload the profile and update active memory so 'go' is immediately visible
    printf "${YELLOW}Reloading environment paths...\n${NC}"
    
    # 1. Update the current script's memory immediately (failsafe)
    export PATH="$PATH:/usr/local/go/bin"
    
    # 2. Source the profile for the rest of the orchestration session
    if [ -f ~/.profile ]; then
        source ~/.profile
    fi

    # Verify it's now visible
    if command -v go &> /dev/null; then
        EXT_VER=$(go version | awk '{print $3}')
        printf "${GREEN}Go is now active and accessible in the current session! (${EXT_VER})\n${NC}"
    else
        printf "${RED}Warning: Go was installed but is not yet accessible in this shell instance.\n${NC}"
    fi
}