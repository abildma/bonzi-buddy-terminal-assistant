#!/bin/bash
# Complete fix for Bonzi Buddy installation in ~/.bonzi-buddy
# Addresses command-not-found handling, autocompletion, and UI consistency

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${MAGENTA}Bonzi Buddy Complete Fix Tool${NC}"
echo "This script will fix all known issues with your installation."
echo ""

# 1. Check that ~/.bonzi-buddy exists
if [ ! -d "$HOME/.bonzi-buddy" ]; then
    echo -e "${RED}Error: ~/.bonzi-buddy directory not found!${NC}"
    echo "Please run ./install_hidden.sh first."
    exit 1
fi

# Set the Bonzi Buddy directory
BONZI_DIR="$HOME/.bonzi-buddy"

# 2. Fix command-not-found handler in .zshrc
echo -e "${BLUE}Fixing command-not-found handler...${NC}"
if grep -q "command_not_found_handler" "$HOME/.zshrc"; then
    # Remove existing handler
    sed -i '/command_not_found_handler/,/}/d' "$HOME/.zshrc" 2>/dev/null
    if [ $? -ne 0 ]; then
        # If sed -i fails (e.g., on macOS), use this alternative approach
        TMP_FILE="$(mktemp)"
        grep -v "command_not_found_handler" "$HOME/.zshrc" > "$TMP_FILE"
        mv "$TMP_FILE" "$HOME/.zshrc"
    fi
fi

# Add the correct handler
cat << EOF >> "$HOME/.zshrc"

# Bonzi Buddy Command Not Found Handler
command_not_found_handler() {
    "$BONZI_DIR/command_not_found.sh" "\$@"
    return \$?
}
EOF

# 3. Fix autocompletion for subo
echo -e "${BLUE}Setting up auto-completion...${NC}"
# Ensure _subo exists
cp "$BONZI_DIR/subo_completion.zsh" "$BONZI_DIR/_subo" 2>/dev/null

# Add proper completion setup
cat << 'EOF' >> "$HOME/.zshrc"

# Manually register subo completion
compdef _subo_complete subo
_subo_complete() {
    local -a _command_args
    local -a _apt_commands
    
    _apt_commands=(
        "update:Refresh available updates"
        "upgrade:Install available upgrades"
        "install:Install new packages"
        "remove:Remove packages"
        "purge:Remove packages and their configuration files"
        "autoremove:Remove automatically installed packages no longer needed"
        "list:List packages"
        "search:Search for packages"
        "show:Show package details"
        "clean:Clean local package cache"
    )
    
    case "$words[2]" in
        apt)
            # Second level completion for apt commands
            _describe "apt commands" _apt_commands
            ;;
        *)
            # First level completion for commands that might need sudo
            _command_args=(
                "apt:Advanced package tool"
                "apt-get:Legacy package management tool"
                "systemctl:Control systemd services"
                "service:Control system services"
                "docker:Manage Docker containers"
                "cp:Copy files"
                "mv:Move files"
                "rm:Remove files"
                "nano:Text editor"
                "vim:Text editor"
                "find:Find files"
            )
            _describe "commands" _command_args
            ;;
    esac
}
EOF

# 4. Fix command_explanations.sh to ensure it's working
echo -e "${BLUE}Fixing command explanations...${NC}"
cat > "$BONZI_DIR/command_explanations.sh" << 'EOF'
#!/bin/bash
# Command explanations for Bonzi Buddy

# Function to get explanation for a command
get_command_explanation() {
    local cmd="$1"
    case "$cmd" in
        ls) echo "List directory contents" ;;
        cd) echo "Change directory" ;;
        cp) echo "Copy files and directories" ;;
        mv) echo "Move/rename files and directories" ;;
        rm) echo "Remove files or directories" ;;
        mkdir) echo "Create directories" ;;
        chmod) echo "Change file permissions" ;;
        chown) echo "Change file owner and group" ;;
        grep) echo "Search text using patterns" ;;
        find) echo "Search for files in a directory hierarchy" ;;
        ps) echo "Report process status" ;;
        kill) echo "Terminate processes" ;;
        sudo) echo "Execute a command as another user (typically root)" ;;
        apt) echo "Advanced package tool for Debian/Ubuntu" ;;
        "apt update") echo "Update list of available packages" ;;
        "apt upgrade") echo "Upgrade the installed packages" ;;
        "apt install") echo "Install new packages" ;;
        "apt remove") echo "Remove packages" ;;
        "apt autoremove") echo "Remove automatically all unused packages" ;;
        "apt search") echo "Search for packages" ;;
        "apt list") echo "List packages with criteria" ;;
        "apt show") echo "Show package details" ;;
        cat) echo "Concatenate and display files" ;;
        less) echo "View file contents with pagination" ;;
        man) echo "Display system manual pages" ;;
        ln) echo "Create links between files" ;;
        df) echo "Report file system disk space usage" ;;
        du) echo "Estimate file space usage" ;;
        free) echo "Display amount of free and used memory" ;;
        top) echo "Display Linux processes" ;;
        uname) echo "Print system information" ;;
        whoami) echo "Print effective user ID" ;;
        tar) echo "Manipulate tape archives" ;;
        zip) echo "Package and compress files" ;;
        unzip) echo "Extract compressed files" ;;
        ssh) echo "OpenSSH remote login client" ;;
        scp) echo "Secure copy (remote file copy program)" ;;
        ping) echo "Send ICMP ECHO_REQUEST to network hosts" ;;
        ifconfig) echo "Configure network interface parameters" ;;
        ip) echo "Show/manipulate routing, devices, policy routing and tunnels" ;;
        systemctl) echo "Control the systemd system and service manager" ;;
        journalctl) echo "Query the systemd journal" ;;
        docker) echo "Docker container management" ;;
        git) echo "The fast distributed version control system" ;;
        curl) echo "Transfer data from or to a server" ;;
        wget) echo "Non-interactive network downloader" ;;
        *) echo "" ;;
    esac
}

# Export function
export -f get_command_explanation
EOF
chmod +x "$BONZI_DIR/command_explanations.sh"

# 5. Regenerate the wrappers for subo and bonzi
echo -e "${BLUE}Regenerating command wrappers...${NC}"
# Fix subo-wrapper
cat > "$BONZI_DIR/subo-wrapper" << EOF
#!/bin/bash
# Wrapper script for subo
"$BONZI_DIR/subo.sh" "\$@"
EOF
chmod +x "$BONZI_DIR/subo-wrapper"

# Fix bonzi-wrapper
cat > "$BONZI_DIR/bonzi-wrapper" << EOF
#!/bin/bash
# Wrapper script for bonzi
"$BONZI_DIR/bonzi.sh" "\$@"
EOF
chmod +x "$BONZI_DIR/bonzi-wrapper"

# 6. Export variables for current session
export BONZI_BUDDY_DIR="$BONZI_DIR"
export PATH="$HOME/bin:$PATH"

echo -e "${GREEN}Bonzi Buddy fixes complete!${NC}"
echo -e "${YELLOW}To apply all changes, please restart your shell:${NC}"
echo -e "${MAGENTA}exec zsh${NC}"
echo ""
echo -e "${BLUE}After restarting, try the following:${NC}"
echo -e "1. Type a non-existent command like ${GREEN}lsl${BLUE} (should suggest ls -l)"
echo -e "2. Type ${GREEN}subo apt${BLUE} and press Tab (should show completions)"
echo -e "3. Try ${GREEN}subo apt uprade${BLUE} (should detect and correct typo)"
