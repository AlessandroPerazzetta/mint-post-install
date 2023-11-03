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
 
# List of selectable installed packages:

- bwm-ng 
- screen
- neovim 
- filezilla 
- meld 
- vlc 
- git 
- htop 
- jq
- apt-transport-https
- curl
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
- codium extensions uninstalled
    * ms-toolsai.jupyter
    * ms-toolsai.jupyter-keymap
    * ms-toolsai.jupyter-renderers
    * ms-toolsai.vscode-jupyter-cell-tags
    * ms-toolsai.vscode-jupyter-slideshow
- marktext
- dbeaver-ce_latest_amd64
- smartgit-23_1-preview-12
- MQTT-Explorer
- keepassxc
- qownnotes
- virtualbox
- kicad
- freecad
- telegram
- rust
- python 3.6.15 (source install)
- python 3.8 (package install)
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

# List installed scripts:

- vscodium-json-updater.sh

# List installed codium extensions:

- Arduino (Arduino for Visual Studio Code)
- Better TOML (Better TOML Language support)
- C/C++ (C/C++ IntelliSense, debugging, and code browsing)
- CodeLLDB (A native debugger powered by LLDB. Debug C++, Rust and other compiled languages)
- crates (Helps Rust developers managing dependencies with Cargo.toml. Only works with dependencies from crates.io)
- Error Lens (Improve highlighting of errors, warnings and other language diagnostic)
- Pylance (A performant, feature-rich language server for Python in VS Code)
- Python (IntelliSense (Pylance), Linting, Debugging (multi-threaded, remote), Jupyter Notebooks, code formatting, refactoring, unit tests, and more)
- rust-analyzer (An alternative rust language server to the RLS)

# List installed languagess:
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
