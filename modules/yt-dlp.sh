#!/usr/bin/env bash
# Module: yt-dlp
# Called by install-packages.sh orchestrator

install_yt_dlp() {
    printf "${YELLOW}Installing yt-dlp...\n${NC}"
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    sudo ln -s /usr/local/bin/yt-dlp /usr/bin/yt-dlp
}
