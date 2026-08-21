#!/usr/bin/env bash
# Module: codebase-memory-mcp
# DESC: Codebase Memory MCP
# DEFAULT: on
# ORDER: 190
# Called by install-packages.sh orchestrator

install_codebase_memory_mcp() {
    printf "${YELLOW}Installing codebase-memory-mcp...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
    printf "Creating codebase-memory-mcp directory and manual download from repository ...\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"

    INSTALLATION_DIR="/opt/codebase-memory-mcp"
  
    # Ensure parent directory has the correct permissions for uv restrictions/permissions problems
    sudo chmod 755 "$(dirname "$INSTALLATION_DIR")"
    
    # Check if the installation directory already exists
    if [ -d "$INSTALLATION_DIR" ]; then
        printf "${RED}Directory $INSTALLATION_DIR already exists. Aborting installation.\n${NC}"
        printf "${RED}Please remove the existing directory or choose a different installation path.\n${NC}"
        exit 1
    fi

    # Create the installation directory with appropriate permissions
    sudo mkdir "$INSTALLATION_DIR"
    sudo chown "$CURRENT_USER:$CURRENT_USER" "$INSTALLATION_DIR"

    # Detect Linux Architecture
    ARCH_RAW="$(uname -m)"
    case "$ARCH_RAW" in
    x86_64|amd64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) echo "Error: Unsupported Linux architecture '$ARCH_RAW'" >&2; exit 1 ;;
    esac

    ARCHIVE="codebase-memory-mcp-linux-${ARCH}-portable.tar.gz"
    DOWNLOAD_URL="https://github.com/DeusData/codebase-memory-mcp/releases/latest/download/${ARCHIVE}"

    echo "Platform: Linux | Arch: ${ARCH}"
    echo "Downloading ${ARCHIVE}..."

    # curl -fsSL https://github.com/DeusData/codebase-memory-mcp/releases/latest/download/codebase-memory-mcp-linux-amd64-portable.tar.gz | tar -xz -C /opt/codebase-memory-mcp
    curl -fsSL "$DOWNLOAD_URL" | tar -xz -C "$INSTALLATION_DIR"

    if [ ! -f "$INSTALLATION_DIR/codebase-memory-mcp" ]; then
        printf "${RED}Error: codebase-memory-mcp binary not found in $INSTALLATION_DIR\n${NC}"
        exit 1
    fi

    # Set executable permissions for the binary
    chmod +x "$INSTALLATION_DIR/codebase-memory-mcp"

    # Running agent setup to initialize the installation
    "$INSTALLATION_DIR/codebase-memory-mcp" install --dir "$INSTALLATION_DIR"

    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
    printf "Installation completed\n"
    printf "To uninstall codebase-memory-mcp, run: $INSTALLATION_DIR/codebase-memory-mcp uninstall --dir \"$INSTALLATION_DIR\"${NC}\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
    sleep 3
}
