#!/bin/bash

# Bash-specific command-not-found handler
# This script sets up the command-not-found hook for Bash in various distros

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Ubuntu/Debian style (using /etc/bash.bashrc)
setup_debian_style() {
    echo -e "${BLUE}Setting up Debian/Ubuntu style command-not-found handler...${NC}"
    
    # Create a temporary file with our handler
    cat > /tmp/bonzi_command_not_found << EOF
command_not_found_handle() {
    $SCRIPT_DIR/command_not_found.sh "\$@"
    return \$?
}
EOF
    
    # Try to add it system-wide if we have permission
    if [ -w /etc/bash.bashrc ]; then
        echo -e "${BLUE}Adding handler to /etc/bash.bashrc...${NC}"
        sudo cat /tmp/bonzi_command_not_found >> /etc/bash.bashrc 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully added command-not-found handler to /etc/bash.bashrc${NC}"
            return 0
        fi
    fi
    
    # If system-wide failed, add to user's .bashrc
    echo -e "${YELLOW}Adding handler to user's .bashrc...${NC}"
    cat /tmp/bonzi_command_not_found >> ~/.bashrc
    echo -e "${GREEN}Added command-not-found handler to ~/.bashrc${NC}"
    
    # Clean up
    rm /tmp/bonzi_command_not_found
    return 0
}

# Fedora/RHEL style (using separate file)
setup_fedora_style() {
    echo -e "${BLUE}Setting up Fedora/RHEL style command-not-found handler...${NC}"
    
    # Create directory if it doesn't exist
    if [ ! -d ~/.config/bonzi ]; then
        mkdir -p ~/.config/bonzi
    fi
    
    # Create the handler file
    cat > ~/.config/bonzi/command_not_found.sh << EOF
#!/bin/bash
$SCRIPT_DIR/command_not_found.sh "\$@"
return \$?
EOF
    
    chmod +x ~/.config/bonzi/command_not_found.sh
    
    # Add sourcing to ~/.bashrc if not already there
    if ! grep -q "bonzi/command_not_found.sh" ~/.bashrc; then
        echo -e "${YELLOW}Adding handler to .bashrc...${NC}"
        cat >> ~/.bashrc << EOF

# Bonzi Buddy command-not-found handler
command_not_found_handle() {
    ~/.config/bonzi/command_not_found.sh "\$@"
    return \$?
}
EOF
        echo -e "${GREEN}Added command-not-found handler to ~/.bashrc${NC}"
    fi
    
    return 0
}

# Direct integration (simplest approach)
setup_direct_integration() {
    echo -e "${BLUE}Setting up direct command-not-found handler...${NC}"
    
    # Just add the function definition directly to .bashrc
    if ! grep -q "command_not_found_handle" ~/.bashrc; then
        echo -e "${YELLOW}Adding handler directly to .bashrc...${NC}"
        cat >> ~/.bashrc << EOF

# Bonzi Buddy command-not-found handler
command_not_found_handle() {
    $SCRIPT_DIR/command_not_found.sh "\$@"
    return \$?
}
EOF
        echo -e "${GREEN}Added command-not-found handler to ~/.bashrc${NC}"
    fi
    
    return 0
}

# Try to determine distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
else
    DISTRO="unknown"
fi

echo -e "${BLUE}Detected distribution: ${YELLOW}$DISTRO${NC}"

# Setup based on distribution
case "$DISTRO" in
    ubuntu|debian|linuxmint)
        setup_debian_style
        ;;
    fedora|rhel|centos)
        setup_fedora_style
        ;;
    *)
        # Default to direct integration for unknown distros
        setup_direct_integration
        ;;
esac

echo -e "${GREEN}Command-not-found handler setup completed.${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source ~/.bashrc' to activate.${NC}"
