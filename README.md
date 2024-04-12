# Mint post install flavour packages

wget -O - https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main/install-packages.sh | bash

# List system tweaks:

- system Serial permission for user
- mount/umount: allow all user to run commands without pass

# List of required installed packages:

- build-essential
- apt-transport-https
- curl
- python3-serial
- python3-pip
- sshfs
- git

# List of selectable installed packages:

- bwm-ng, screen, htop
- neovim 
- filezilla 
- meld 
- vlc 
- brave-browser
- brave-browser extensions
  * bypass-adblock-detection
  * hls-downloader
  * i-dont-care-about-cookies
  * keepassxc-browser
  * session-buddy
  * the-marvellous-suspender
  * url-tracking-stripper-red
  * video-downloader-plus
  * stream-cleaner
- remmina
- remmina-plugin-rdp
- remmina-plugin-secret
- codium
- codium marketplace replacement (local config)
- codium extensions installed
  * bungcip.better-toml
  * rust-lang.rust-analyzer
  * jinxdash.prettier-rust
  * kogia-sima.vscode-sailfish
  * ms-python.python
  * ms-python.vscode-pylance
  * ms-vscode.cpptools
  * serayuzgur.crates
  * usernamehw.errorlens
  * vadimcn.vscode-lldb
  * jeff-hykin.better-cpp-syntax
  * aaron-bond.better-comments
  * vsciot-vscode.vscode-arduino
  * kamikillerto.vscode-colorize
  * oderwat.indent-rainbow
  * eamodio.gitlens
- codium extensions uninstalled
  * ms-toolsai.jupyter
  * ms-toolsai.jupyter-keymap
  * ms-toolsai.jupyter-renderers
  * ms-toolsai.vscode-jupyter-cell-tags
  * ms-toolsai.vscode-jupyter-slideshow
- marktext
- dbeaver-ce_latest_amd64
- smartgit-23_1_2
- MQTT-Explorer
- arduino-cli
- keepassxc
- qownnotes
- virtualbox
- kicad
- freecad
- telegram
- rust
- python 3.6.15 (source install)
- python 3.8.19 (source install)
- qtcreator + qt5 + qt5 lib + cmake
- bluetooth restart after sleep
- SSH alive interval (15) and count (1)
- borgbackup + vorta gui
- spotify + spicetify
- spotube
- fancontrol (with custom config)

# List uninstalled packages:

- nano
- ed

# ~~List installed scripts:~~

- vscodium-json-updater.sh

> Replaced with local user .config custom product.json file

# List installed codium extensions:

- Better TOML Language support
  * bungcip.better-toml
- Rust language support for Visual Studio Code
  * rust-lang.rust-analyzer
- Prettier Rust is a code formatter that autocorrects bad syntax
  * jinxdash.prettier-rust
- Syntax Highlighting for Sailfish Templates in VSCode
  * kogia-sima.vscode-sailfish
- Python extension for Visual Studio Code
  * ms-python.python
  * ~~ms-python.vscode-pylance~~
- C/C++ for Visual Studio Code
  * ms-vscode.cpptools
- Helps Rust developers managing dependencies with Cargo.toml.
  * serayuzgur.crates
- Improve highlighting of errors, warnings and other language diagnostics.
  * usernamehw.errorlens
- CodeLLDB (A native debugger powered by LLDB. Debug C++, Rust and other compiled languages)
  * vadimcn.vscode-lldb
- The bleeding edge of the C++ syntax
  * jeff-hykin.better-cpp-syntax
- Improve your code commenting by annotating with alert, informational, TODOs, and more!
  * aaron-bond.better-comments
- Arduino for Visual Studio Code
  * vsciot-vscode.vscode-arduino
- A vscode extension to help visualize css colors in files.
  * kamikillerto.vscode-colorize

# List installed languages:

- rust
- python 3.6

# Extra:

- install neovim res
- install xed theme
- install gedit theme
- install VLC Media Library
- add user to dialout group
- add bash aliases
- install imwheel
