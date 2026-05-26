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
| System utils | `bwm-ng` `screen` `htop` `bat` |
| Required packages | `build-essential` `apt-transport-https` `curl` `sshfs` `git` `jq` `pigz` `pbzip2` `pxz` `zip` `unzip` `ripgrep` |

### Selectable modules (interactive checklist)

> **Default** column reflects the pre-selected state when running without `--none`.

#### Desktop

| Module | Default |
|---|---|
| Xed theme resources | on |
| Gedit theme resources | on |
| Cinnamon spices: QRedShift, Bash Sensors, Sensors Monitor (applets) · Back to Monitor, Cinnamon Dynamic Wallpaper (extensions) | on |
| Nemo actions: MKDTS (create dir with current timestamp) | on |
| Personal resources: bash aliases (`l`, `cls`) | on |

#### Terminals

| Module | Default |
|---|---|
| alacritty + resources | on |
| tabby | on |
| tmux + resources | on |
| kitty + resources + libgl fix | off |
| tabby libgl fix | off |

#### Editors & IDEs

| Module | Default |
|---|---|
| neovim | on |
| VS Code + nemo actions + extensions | on |
| Zed editor + nemo actions | on |
| QOwnNotes | on |
| Ferrite editor | on |
| vim + resources | off |
| VSCodium + nemo actions + extensions | off |
| marktext | off |

#### Browsers

| Module | Default |
|---|---|
| Brave browser + extensions | on |
| Brave Origin browser + extensions | off |

#### Development tools

| Module | Default |
|---|---|
| grpcurl | on |
| DBeaver, DBgate | on |
| bruno | on |
| MQTT Explorer | on |
| arduino-cli | on |
| Rust | on |
| Python dev packages, latest pip | on |
| lazygit | off |
| SmartGit | off |
| KiCad, FreeCAD | off |
| Python 3.6.15 (source build), Python 3.8.19 (source build) | off |
| qtcreator + Qt5 | off |

#### System & utilities

| Module | Default |
|---|---|
| FileZilla, meld, unison | on |
| Remmina (RDP/VNC client) | on |
| RustConn (Rust connection manager) | on |
| VLC | on |
| KeePassXC | on |
| VirtualBox | on |
| Solaar (Logitech device manager) | on |
| borgbackup + Vorta GUI | on |
| fancontrol (with custom config) | on |
| fastfetch, nerd-fonts, yt-dlp, cli-amp | on |
| SSH alive settings, SSH skip hosts check | on |
| imwheel | off |
| Bluetooth restart after sleep | off |

#### Messaging & media

| Module | Default |
|---|---|
| Telegram | on |
| Spotify + Spicetify | off |
| Spotube | off |

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
