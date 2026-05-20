#!/usr/bin/env bash
# Module: kitty_libgl_fix
# DESC: kitty libgl fix
# DEFAULT: off
# Called by install-packages.sh orchestrator

install_kitty_libgl_fix() {
    # printf "${YELLOW}Installing kitty libgl fix to allow kitty on OPENGL < 2/3 on /etc/profile.d/kitty.sh...\n${NC}"
    # sudo bash -c "echo -e 'export LIBGL_ALWAYS_SOFTWARE=1' > /etc/profile.d/kitty.sh"
    # sudo chmod +x /etc/profile.d/kitty.sh

    TARGET_FILE="/usr/bin/kitty-terminal"
    printf "${YELLOW}Installing kitty-terminal with libgl fix to allow kitty on OPENGL < 2/3 on $TARGET_FILE...\n${NC}"
    # Use sudo and tee to write lines to the file
    echo -e '#!/usr/bin/env bash\nLIBGL_ALWAYS_SOFTWARE=1 kitty'       | sudo tee "$TARGET_FILE" > /dev/null
    # Make the file executable
    sudo chmod +x "$TARGET_FILE"
}
