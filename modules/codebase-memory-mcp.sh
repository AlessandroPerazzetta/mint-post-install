#!/usr/bin/env bash
# Module: codebase-memory-mcp
# DESC: Codebase Memory MCP
# DEFAULT: on
# ORDER: 210
# Called by install-packages.sh orchestrator

install_codebase_memory_mcp() {
    printf "${YELLOW}Installing codebase-memory-mcp...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
    printf "Writing codebase-memory-mcp repository ...\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"

    sudo mkdir /opt/codebase-memory-mcp
    sudo chown alessandro:alessandro /opt/codebase-memory-mcp/
    cd /opt/codebase-memory-mcp/
    curl -#fsSLO https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh
    chmod +x install.sh
    ./install.sh --dir /opt/codebase-memory-mcp/ >> /opt/codebase-memory-mcp/install.log

    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
    printf "Installation completed, log file available at /opt/codebase-memory-mcp/install.log"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
    cat /opt/codebase-memory-mcp/install.log
    sleep 
}
