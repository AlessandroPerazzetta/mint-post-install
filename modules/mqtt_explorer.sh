#!/usr/bin/env bash
# Module: mqtt_explorer
# Called by install-packages.sh orchestrator

install_mqtt_explorer() {
    printf "${YELLOW}Installing MQTT-Explorer...\n${NC}"
    sudo mkdir -p /opt/mqtt-explorer/
    #curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -O -L
    #sudo chmod +x *.AppImage
    curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/mqtt-explorer/mqtt-explorer
    sudo chmod +x /opt/mqtt-explorer/mqtt-explorer
    sudo curl -L https://raw.githubusercontent.com/thomasnordquist/MQTT-Explorer/master/icon.png -o /opt/mqtt-explorer/icon.png
    # ----> OUT
    # [Desktop Entry]
    # Name=MQTT Explorer
    # GenericName=MQTT client
    # Comment=An all-round MQTT client that provides a structured topic overview
    # Categories=Development;
    # Terminal=false
    # Type=Application
    # Path=/opt/mqtt-explorer/
    # Exec=/opt/mqtt-explorer/mqtt-explorer
    # StartupWMClass=mqtt-explorer
    # StartupNotify=true
    # Keywords=MQTT
    # Icon=/opt/mqtt-explorer/icon.png
    sudo bash -c "echo -e '[Desktop Entry]\nName=MQTT Explorer\nGenericName=MQTT client\nComment=An all-round MQTT client that provides a structured topic overviewCategories=Development;\nTerminal=false\nType=Application\nPath=/opt/mqtt-explorer/\nExec=/opt/mqtt-explorer/mqtt-explorer\nStartupWMClass=mqtt-explorer\nStartupNotify=true\nKeywords=MQTT\nIcon=/opt/mqtt-explorer/icon.png' >> /usr/share/applications/mqtt-explorer.desktop"
}
