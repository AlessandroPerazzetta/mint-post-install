#!/usr/bin/env bash
# Module: vscodium_ext
# Called by install-packages.sh orchestrator

install_vscodium_ext() {
    printf "${YELLOW}VSCodium extensions ...\n${NC}"
    if ! command -v codium &> /dev/null
    then
        printf "${RED}Installing/Uninstalling vscodium extensions failed, codium could not be found...\n${NC}"
    else
        printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
        export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'
        export VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'
        export VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'
        export VSCODE_GALLERY_CONTROL_URL=''

        # Extension removed from array:
        #     Temporary removed, installed from file (v1.24.5) due to errors:
        #     - https://github.com/VSCodium/vscodium/issues/2300
        #     - https://github.com/getcursor/cursor/issues/2976
        #    ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
        printf "${LCYAN}Installing extension from file:\n${NC}"
        mkdir -p /tmp/vscodium_exts/ && cd /tmp/vscodium_exts/
        curl -s https://api.github.com/repos/jeanp413/open-remote-ssh/releases/latest | grep "browser_download_url.*vsix" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
        curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases/tags/v1.24.5 | grep "browser_download_url.*vsix"|grep "linux-x64" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
        curl --compressed -fsSLo GitHub.copilot-1.257.1316.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/1.257.1316/vspackage
        curl --compressed -fsSLo GitHub.copilot-chat-0.23.2024120501.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/0.23.2024120501/vspackage
        find . -type f -name "*.vsix" -exec codium --install-extension {} --force --log debug \;

        declare -A VSCODEEXTlistAdd=(
            ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
            ["Even Better TOML: Fully-featured TOML support"]="tamasfe.even-better-toml"
            ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
            ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
            ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
            ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
            ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
            ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
            ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
            ["isort: Import organization support for Python files using isort."]="ms-python.isort"
            ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
            ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
            ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
            ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
            ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
            ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
            ["Dependi: Empowers developers to efficiently manage dependencies and address vulnerabilities in Rust, Go, JavaScript, Typescript, PHP and Python projects."]="fill-labs.dependi"
            ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
            ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
            ["Todo Tree: Show TODO, FIXME, etc. comment tags in a tree view"]="Gruntfuggly.todo-tree"
            ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
            ["Readable Indent"]="cnojima.readable-indent"
            ["VSCode Great Icons"]="emmanuelbeziat.vscode-great-icons"
            ["Protobuf VSC"]="DrBlury.protobuf-vsc"
            ["JSON Beautify JSON"]="Meezilla.json"
        )
        for i in "${!VSCODEEXTlistAdd[@]}"; do
            #echo "Key: $i value: ${VSCODEEXTlistAdd[$i]}"
            printf "${LCYAN}- Extension: ${i}\n${NC}"
            codium --install-extension ${VSCODEEXTlistAdd[$i]} --force --log debug
            printf "\n${NC}"
        done

        printf "${YELLOW}Uninstalling vscodium extensions ...\n${NC}"
        declare -A VSCODEEXTlistDel=(
            ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
            ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
            ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
            ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
            ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
        )
        for i in "${!VSCODEEXTlistDel[@]}"; do
            #echo "Key: $i value: ${VSCODEEXTlistDel[$i]}"
            printf "${LCYAN}- Extension: ${i}\n${NC}"
            codium --uninstall-extension ${VSCODEEXTlistDel[$i]} --log debug
            printf "\n${NC}"
        done
    fi
}
