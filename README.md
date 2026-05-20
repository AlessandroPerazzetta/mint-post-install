# mint-post-install

Post-install automation for Linux Mint. Runs system tweaks, installs required
tooling, and presents an interactive checklist of optional packages — all from a
single `curl | bash` one-liner.

## Quick Start

```bash
# Run with defaults
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main/install-packages.sh | bash

# Run with all options pre-deselected
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main/install-packages.sh | bash -s -- --none
```

For branch testing and advanced usage see [ref/instructions.md](ref/instructions.md).

## Project Structure

```
install-packages.sh     # thin orchestrator
lib/
  colors.sh             # terminal color variables
  helpers.sh            # shared functions (command_exists, install_brave_extensions)
modules/
  <key>.sh              # one module per selectable item — auto-discovered at runtime
ref/
  instructions.md       # testing and branch usage guide
```

Each module carries its own metadata:

```bash
# DESC: Human readable label shown in the checklist
# DEFAULT: on|off
# ORDER: <number>          # execution priority — lower runs first
# REQUIRE: <dep-key>      # omit if no dependency
```

- `ORDER` controls both the checklist display sequence and the installation sequence. Use multiples of 10 to leave room for future modules.
- `REQUIRE` names a module that must run first. The orchestrator auto-includes it if the user didn't select it.

Dropping a new `.sh` file into `modules/` is all that is needed to add it to the menu.

## What Gets Installed

### Always — system setup

| Item | Description |
|---|---|
| System serial permission | Adds user to `dialout` group |
| System tweaks | mount/umount without password, misc tweaks |
| Required packages | `build-essential` `apt-transport-https` `curl` `sshfs` `git` `jq` `pigz` `pbzip2` `pxz` `zip` `unzip` `ripgrep` |

### Selectable modules (interactive checklist)

#### Desktop
- Cinnamon spices: QRedShift, Bash Sensors, Sensors Monitor (applets) · Back to Monitor, Cinnamon Dynamic Wallpaper (extensions)
- Nemo actions: MKDTS (create dir with current timestamp)
- Xed theme resources, Gedit theme resources

#### Terminals
- alacritty + resources
- kitty + resources + libgl fix
- tabby + libgl fix
- tmux + resources

#### Editors & IDEs
- vim + resources
- neovim
- VS Code + nemo actions + extensions
- VSCodium + nemo actions + extensions
- Zed editor + nemo actions
- marktext
- QOwnNotes
- Ferrite editor

#### Browsers
- Brave browser + extensions
- Brave Origin browser + extensions

#### Development tools
- lazygit, SmartGit
- grpcurl
- DBeaver, DBgate
- bruno
- MQTT Explorer
- arduino-cli
- KiCad, FreeCAD
- Rust
- Python 3.6.15 (source build), Python 3.8.19 (source build)
- Python dev packages, latest pip
- qtcreator + Qt5

#### System & utilities
- FileZilla, meld, unison
- remmina (RDP/VNC client)
- VLC
- KeePassXC
- VirtualBox
- Solaar (Logitech device manager)
- borgbackup + Vorta GUI
- fancontrol (with custom config)
- fastfetch, nerd-fonts, yt-dlp, cli-amp
- imwheel
- SSH alive settings, SSH skip hosts check
- Bluetooth restart after sleep

#### Messaging & media
- Telegram
- Spotify + Spicetify
- Spotube

### Browser extensions

#### Brave / Brave Origin
- ublock-origin, bypass-adblock-detection, hls-downloader
- i-dont-care-about-cookies, keepassxc-browser
- session-buddy, the-marvellous-suspender
- url-tracking-stripper-red, video-downloader-plus
- youtube-nonstop, user-agent-switcher-for-c
- modheader-modify-http-hea, enhancer-for-youtube, disable-twitch-extensions

### VS Code / VSCodium extensions

Both editors install the same extension set. Exceptions are noted.

**Installed:**
- Better Comments, Even Better TOML, Prettier
- Syntax Highlighter, Better C++ Syntax
- colorize, indent-rainbow, Readable Indent, VSCode Great Icons
- Serial Monitor
- Arduino Community Edition
- isort, Pylint, Python, Pylance, CodeLLDB
- Prettier (Rust), rust-analyzer, Dependi
- Markdown Preview Enhanced
- Error Lens, Todo Tree
- Shades of Purple
- Protobuf VSC, JSON Beautify
- C/C++
- Remote - SSH *(VS Code only — built-in SSH available)*
- GitHub Copilot + Copilot Chat *(VS Code only — not on Open VSX)*

**Removed / replaced:**

| Removed | Replacement |
|---|---|
| Better TOML | Even Better TOML |
| vscode-arduino | Arduino Community Edition |
| crates | Dependi |
| vscode-proto3 | Protobuf VSC |
| SSH Host Requirements (jeanp413) | Remote - SSH (VS Code) |
| GitLens | — |
| Jupyter suite (5 extensions) | — |
| GitHub Copilot *(VSCodium only)* | — |

## Fonts

Installed by the `nerd-fonts` module from [nerdfonts.com](https://www.nerdfonts.com/font-downloads):
- FiraCode
- JetBrainsMono

## Adding a New Module

1. Create `modules/<key>.sh`:

```bash
#!/usr/bin/env bash
# Module: <key>
# DESC: Description shown in the checklist
# DEFAULT: on|off
# ORDER: <number>          # pick a value relative to its neighbors
# REQUIRE: <dep-key>      # omit if no dependency
# Called by install-packages.sh orchestrator

install_<key>() {
    # install logic
}
```

2. The module is auto-discovered — no changes to any other file are needed.
