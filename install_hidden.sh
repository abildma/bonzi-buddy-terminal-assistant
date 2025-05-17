#!/bin/bash
# Installer for Bonzi Buddy - Hidden Directory Edition
# This installer places all files in ~/.bonzi-buddy

# Colors for friendly messages
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

# ASCII art banner
echo -e "${MAGENTA}"
cat << "EOF"
 ____                     _    ____            _     _       
| __ )  ___  _ __  ____ (_)  | __ ) _   _  __| | __| |_   _ 
|  _ \ / _ \| '_ \|_  / | |  |  _ \| | | |/ _` |/ _` | | | |
| |_) | (_) | | | |/ /  | |  | |_) | |_| | (_| | (_| | |_| |
|____/ \___/|_| |_/___| |_|  |____/ \__,_|\__,_|\__,_|\__, |
                                                       |___/ 
EOF
echo -e "${NC}"

echo -e "${YELLOW}Welcome to Bonzi Buddy Installation!${NC}"
echo -e "${CYAN}All files will be installed to ~/.bonzi-buddy${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )"
INSTALL_DIR="$HOME/.bonzi-buddy"

# Check if ZSH is available
if [ -z "$(which zsh)" ]; then
    echo -e "${RED}Error: Zsh is not installed. Bonzi Buddy requires Zsh to function.${NC}"
    echo -e "${YELLOW}Please install Zsh and try again.${NC}"
    exit 1
fi

# Check if a previous installation exists
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}An existing Bonzi Buddy installation was found.${NC}"
    echo -e "${BLUE}Would you like to remove it and reinstall? (y/n)${NC}"
    read -r response
    if [[ "$response" == "y" ]]; then
        echo -e "${YELLOW}Removing previous installation...${NC}"
        rm -rf "$INSTALL_DIR"
    else
        echo -e "${BLUE}Installation cancelled. Exiting...${NC}"
        exit 0
    fi
fi

# Create installation directory
echo -e "${BLUE}Creating installation directory at ${INSTALL_DIR}...${NC}"
mkdir -p "$INSTALL_DIR"

# Copy all necessary files
echo -e "${BLUE}Copying Bonzi Buddy files...${NC}"
cp "$SCRIPT_DIR/bonzi.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/subo.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/command_not_found.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/zsh_setup.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/command_explanations.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/subo_completion.zsh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/_subo" "$INSTALL_DIR/" 2>/dev/null || cp "$SCRIPT_DIR/subo_completion.zsh" "$INSTALL_DIR/_subo"

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
chmod +x "$INSTALL_DIR/bonzi.sh"
chmod +x "$INSTALL_DIR/subo.sh"
chmod +x "$INSTALL_DIR/command_not_found.sh"
chmod +x "$INSTALL_DIR/zsh_setup.sh"
chmod +x "$INSTALL_DIR/command_explanations.sh"
chmod +x "$INSTALL_DIR/_subo"

# Create wrappers for the commands
echo -e "${BLUE}Creating command wrappers...${NC}"

# Create subo wrapper
cat > "$INSTALL_DIR/subo-wrapper" << EOF
#!/bin/bash
# Wrapper for subo with hardcoded path
"$INSTALL_DIR/subo.sh" "\$@"
EOF
chmod +x "$INSTALL_DIR/subo-wrapper"

# Create bonzi wrapper
cat > "$INSTALL_DIR/bonzi-wrapper" << EOF
#!/bin/bash
# Wrapper for bonzi with hardcoded path
"$INSTALL_DIR/bonzi.sh" "\$@"
EOF
chmod +x "$INSTALL_DIR/bonzi-wrapper"

# Create bin directory if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
    echo -e "${BLUE}Creating ~/bin directory...${NC}"
    mkdir -p "$HOME/bin"
fi

# Create symbolic links
echo -e "${BLUE}Creating symbolic links in ~/bin...${NC}"
ln -sf "$INSTALL_DIR/subo-wrapper" "$HOME/bin/subo"
ln -sf "$INSTALL_DIR/bonzi-wrapper" "$HOME/bin/bonzi"

# Clean up any previous configuration
echo -e "${BLUE}Cleaning up previous configurations...${NC}"
if [ -f "$HOME/.zshrc" ]; then
    # Create backup
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    
    # Remove any previous Bonzi Buddy entries
    TMP_FILE="$(mktemp)"
    grep -v "# Bonzi Buddy" "$HOME/.zshrc" | 
    grep -v "BONZI_BUDDY_DIR" | 
    grep -v "bonzi_preexec" |
    grep -v "command_not_found_handler" > "$TMP_FILE"
    
    # Replace original file if temp file exists
    if [ -s "$TMP_FILE" ]; then
        mv "$TMP_FILE" "$HOME/.zshrc"
    else
        rm "$TMP_FILE"
    fi
fi

# Add configuration to .zshrc
echo -e "${GREEN}Adding Bonzi Buddy configuration to .zshrc...${NC}"
cat << EOF >> "$HOME/.zshrc"

# Bonzi Buddy - Terminal Assistant
export BONZI_BUDDY_DIR="$INSTALL_DIR"

# Add ~/bin to PATH if not already there
if [[ ":\$PATH:" != *":\$HOME/bin:"* ]]; then
    export PATH="\$HOME/bin:\$PATH"
fi

# Command Not Found Handler
command_not_found_handler() {
    "\$BONZI_BUDDY_DIR/command_not_found.sh" "\$@"
    return \$?
}

# Enable tab completion
fpath=("\$BONZI_BUDDY_DIR" \$fpath)
autoload -Uz compinit && compinit
EOF

# Make Bonzi Buddy available in the current shell
export BONZI_BUDDY_DIR="$INSTALL_DIR"
export PATH="$HOME/bin:$PATH"

echo -e "${BRIGHT_GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Bonzi Buddy has been installed to ${INSTALL_DIR}${NC}"
echo -e "${CYAN}The following commands are now available:${NC}"
echo -e "  ${GREEN}bonzi${NC} - Check for typos in commands"
echo -e "  ${GREEN}subo${NC}  - Run commands with sudo and typo-checking"
echo ""
echo -e "${BLUE}For best results, please restart your terminal or run:${NC}"
echo -e "${MAGENTA}exec zsh${NC}"
echo ""
echo -e "${YELLOW}To uninstall Bonzi Buddy, run:${NC}"
echo -e "${CYAN}rm -rf ~/.bonzi-buddy${NC}"
echo -e "${CYAN}Then remove the Bonzi Buddy section from your ~/.zshrc${NC}"
