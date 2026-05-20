#!/usr/bin/env bash
# Module: lazygit
# Called by install-packages.sh orchestrator

install_lazygit() {
    printf "${YELLOW}Installing lazygit latest from Github...\n${NC}"
    # Install dependencies
    # printf "${YELLOW}Installing dependencies for lazygit..\n${NC}"
    # sudo apt-get install build-essential libssl-dev libreadline-dev zlib1g-dev curl

    # Get the latest release tag for Lazygit from GitHub API
    latest_version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    # Detect OS and architecture
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    case "$arch" in
      x86_64) arch="x86_64" ;;
      arm64|aarch64) arch="arm64" ;;
      armv6l) arch="armv6" ;;
      i386|i686) arch="32-bit" ;;
      *) echo "Unsupported architecture: $arch" && exit 1 ;;
    esac

    # Construct the download URL
    filename="lazygit_${latest_version#v}_${os}_${arch}.tar.gz"
    url="https://github.com/jesseduffield/lazygit/releases/download/${latest_version}/${filename}"

    echo "Downloading $url"
    curl -fsSLo /tmp/${filename} $url

    # Extract the tar.gz file (replace with your actual filename if different)
    tar -xzf /tmp/${filename} -C /tmp/

    # Move the binary to /usr/local/bin (you may need sudo)
    sudo mv /tmp/lazygit /usr/local/bin/

    # Ensure it's executable
    sudo chmod +x /usr/local/bin/lazygit
}
