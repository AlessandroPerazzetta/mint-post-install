#!/usr/bin/env bash
# Module: qt_stuff
# DESC: qtcreator + qt5
# DEFAULT: off
# ORDER: 460
# Called by install-packages.sh orchestrator

install_qt_stuff() {
    printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
    sudo apt-get -y install cmake qtcreator qt5-default libqt5svg5* libqt5qml* libqt5xml* qtdeclarative5-dev
}
