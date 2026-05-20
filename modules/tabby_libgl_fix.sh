#!/usr/bin/env bash
# Module: tabby_libgl_fix
# DESC: tabby libgl fix
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_tabby_libgl_fix() {
    TARGET_FILE="/usr/bin/tabby-terminal"
    printf "${YELLOW}Installing tabby-terminal with libgl fix to allow tabby on OPENGL < 2/3 on $TARGET_FILE...\n${NC}"
    # Use sudo and tee to write lines to the file
    echo -e '#!/usr/bin/env bash\nLIBGL_ALWAYS_SOFTWARE=1 tabby'       | sudo tee "$TARGET_FILE" > /dev/null
    # Make the file executable
    sudo chmod +x "$TARGET_FILE"
}
