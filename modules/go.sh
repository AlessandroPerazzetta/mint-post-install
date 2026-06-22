#!/usr/bin/env bash
# Module: go
# DESC: Go Language
# DEFAULT: off
# ORDER: 411
# Called by install-packages.sh orchestrator

install_go() {
    printf "${YELLOW}Installing Go...\n${NC}"

    # Check if Go is installed and get version
    if command_exist go &> /dev/null
    then
        GO_VERSION=$(go version | awk '{print $3}')
        printf "${GREEN}Go is already installed. Version: ${GO_VERSION}\n${NC}"
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

    printf "${GREEN}Latest Go Linux release package: ${LATEST_GO_RELEASE}\n${NC}"

    # Optional: Extract just the version number (e.g., "go1.22.1")
    VERSION_NUMBER=$(echo "$LATEST_GO_RELEASE" | sed 's/\.linux-amd64\.tar\.gz//')
    printf "${GREEN}Version: ${VERSION_NUMBER}\n${NC}"


    # Check if the version installed is below the latest version
    if [ -n "$GO_VERSION" ] && [ "$(printf '%s\n' "$VERSION_NUMBER" "$GO_VERSION" | sort -V -c)" ]; then
        printf "${ORANGE}Installed Go version (${GO_VERSION}) is up to date or newer than the latest release (${VERSION_NUMBER}). Skipping installation.\n${NC}"
        return
    fi

    # Optional: Construct the full download URL
    DOWNLOAD_URL="https://go.dev/dl/$LATEST_GO_RELEASE"
    printf "${CYAN}Download URL: ${DOWNLOAD_URL}\n${NC}"

    # Download the latest Go release archive    curl -LO "$DOWNLOAD_URL"
    curl -L -o /tmp/"$LATEST_GO_RELEASE" "$DOWNLOAD_URL"

    # Extract the archive to /usr/local, removing any existing Go installation as sudo to avoid permission issues on /usr/local/    
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/"$LATEST_GO_RELEASE"
    
    # Clean up the downloaded archive    rm /tmp/"$LATEST_GO_RELEASE"
    rm -f /tmp/"$LATEST_GO_RELEASE"

    # Add Go to the PATH if it's not already there
    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.profile; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
        printf "${GREEN}Added Go to PATH in ~/.profile\n${NC}"
    else
        printf "${GREEN}Go is already in PATH.\n${NC}"
    fi
}
