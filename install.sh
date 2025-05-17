#!/bin/zsh

# Bonzi Buddy Installer - Improved with reinstallation support

# Enhanced color palette for a more appealing appearance
GREEN='\033[0;32m'       # Success, commands
BRIGHT_GREEN='\033[1;32m' # Highlighted commands
YELLOW='\033[1;33m'      # Warnings, suggestions
BLUE='\033[0;34m'        # Information
LIGHT_BLUE='\033[0;94m'  # Secondary information
CYAN='\033[0;36m'        # Command descriptions
MAGENTA='\033[0;35m'     # Command highlights
PURPLE='\033[0;35m'      # Bonzi branding
BRIGHT_PURPLE='\033[1;35m' # Enhanced branding
RED='\033[0;31m'         # Errors
GRAY='\033[0;90m'        # Subtle information
WHITE='\033[1;37m'       # Highlighted text
BOLD='\033[1m'           # Bold text
UNDERLINE='\033[4m'      # Underlined text
NC='\033[0m'             # No Color (reset)

# ASCII art banner
echo -e "${PURPLE}"
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
echo -e "${CYAN}Note: Bonzi Buddy currently only supports Zsh${NC}"
echo ""

# Get the directory where the script is located - Zsh compatible approach
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
else
    # If BASH_SOURCE is not available (Zsh), use $0 instead
    SCRIPT_DIR="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
fi

# Pre-install cleanup - Clean up any previous installation remnants
echo -e "${BLUE}Checking for previous installation remnants...${NC}"

# Function to clean .zshrc file of any previous Bonzi Buddy entries
clean_zshrc() {
    if [[ -f ~/.zshrc ]]; then
        echo -e "${YELLOW}Cleaning up any previous Bonzi Buddy entries in .zshrc...${NC}"
        
        # Create a temporary file without previous Bonzi Buddy sections
        TMP_FILE="${HOME}/.zshrc.tmp.$RANDOM"
        
        # Use a safer approach to filter out Bonzi Buddy entries
        cat ~/.zshrc | grep -v "# Bonzi Buddy" | 
                      grep -v "BONZI_BUDDY_DIR" | 
                      grep -v "bonzi.sh" | 
                      grep -v "subo.sh" | 
                      grep -v "bonzi_preexec" |
                      grep -v "command_not_found_handler" > "$TMP_FILE"
        
        # Replace the original with cleaned version if temp file exists and has content
        if [[ -f "$TMP_FILE" && -s "$TMP_FILE" ]]; then
            cp "$TMP_FILE" ~/.zshrc
            rm -f "$TMP_FILE"
            echo -e "${GREEN}Previous Bonzi Buddy entries cleaned from .zshrc${NC}"
        else
            echo -e "${YELLOW}No changes needed to .zshrc${NC}"
            rm -f "$TMP_FILE" 2>/dev/null
        fi
    fi
}

# Clean .zshrc before installation
clean_zshrc

# Unset any existing Bonzi Buddy functions in current shell
unfunction command_not_found_handler 2>/dev/null
unset BONZI_BUDDY_DIR 2>/dev/null

# Make scripts executable
echo -e "${BLUE}Making scripts executable...${NC}"
chmod +x "$SCRIPT_DIR/bonzi.sh"
chmod +x "$SCRIPT_DIR/subo.sh"
chmod +x "$SCRIPT_DIR/command_not_found.sh"
chmod +x "$SCRIPT_DIR/zsh_setup.sh"
chmod +x "$SCRIPT_DIR/bonzi_wrapper.sh"
chmod +x "$SCRIPT_DIR/command_explanations.sh"
chmod +x "$SCRIPT_DIR/subo_completion.bash"
chmod +x "$SCRIPT_DIR/subo_completion.zsh"
chmod +x "$SCRIPT_DIR/subo-wrapper"

# Detect the shell
case "$SHELL" in
    */zsh) CURRENT_SHELL="zsh" ;;
    */bash) CURRENT_SHELL="bash" ;;
    *) CURRENT_SHELL="unknown" ;;
esac
echo -e "${BLUE}Detected shell: ${CURRENT_SHELL}${NC}"

# Check if using Zsh
if [[ "$CURRENT_SHELL" != "zsh" ]]; then
    echo -e "${RED}Warning: Bonzi Buddy currently only supports Zsh!${NC}"
    echo -e "${YELLOW}The installation will continue, but Bonzi Buddy will not work correctly.${NC}"
    echo -e "${BLUE}Consider switching to Zsh or contributing to add support for your shell.${NC}"
    echo ""
    echo -e "${YELLOW}Would you like to continue anyway? (y/n)${NC}"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo -e "${BLUE}Installation cancelled. Goodbye!${NC}"
        exit 0
    fi
fi

# Proceed with Zsh installation
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    echo -e "${BLUE}Setting up for ZSH...${NC}"
    
    # Create backup of .zshrc if it exists
    if [[ -f ~/.zshrc ]]; then
        # Use timestamp for unique backup with proper path expansion
        BACKUP_FILE="${HOME}/.zshrc.backup.bonzi.$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}Creating backup of your .zshrc file to $BACKUP_FILE${NC}"
        cp ~/.zshrc "$BACKUP_FILE"
        echo -e "${GREEN}Backup created successfully${NC}"
    fi
    
    # Add Bonzi Buddy to .zshrc
    echo -e "${GREEN}Adding Bonzi Buddy to your .zshrc...${NC}"
    
    # Create bin directory in home if it doesn't exist
    if [ ! -d ~/bin ]; then
        echo -e "${YELLOW}Creating ~/bin directory...${NC}"
        mkdir -p ~/bin
    fi
    
    # Add bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo -e "${YELLOW}Adding ~/bin to your PATH...${NC}"
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    fi
    
    # Create and install proper subo wrapper for tab completion
    echo -e "${BLUE}Creating subo wrapper for tab completion...${NC}"

    # Create a dynamic wrapper script that uses BONZI_BUDDY_DIR
    cat > "$SCRIPT_DIR/subo-wrapper" << 'WRAPPEREOF'
#!/bin/bash
# Wrapper for subo that uses the environment variable set during installation

# Check if BONZI_BUDDY_DIR is set
if [ -z "$BONZI_BUDDY_DIR" ]; then
    echo "Error: BONZI_BUDDY_DIR is not set. Please make sure Bonzi Buddy is properly installed."
    echo "Try running 'source ~/.zshrc' or reinstalling Bonzi Buddy."
    exit 1
fi

# Run subo.sh with all passed arguments
"$BONZI_BUDDY_DIR/subo.sh" "$@"
WRAPPEREOF

    # Make the wrapper executable
    chmod +x "$SCRIPT_DIR/subo-wrapper"

    # Create symbolic link in bin directory
    echo -e "${BLUE}Installing subo wrapper to ~/bin/subo...${NC}"
    ln -sf "$SCRIPT_DIR/subo-wrapper" ~/bin/subo
    
    # Check if our setup is already in .zshrc
    if grep -q "BONZI_BUDDY_DIR" ~/.zshrc; then
        echo -e "${YELLOW}Bonzi Buddy setup already found in .zshrc. Skipping...${NC}"
    else
        cat << EOF >> ~/.zshrc

# Bonzi Buddy - Terminal Assistant
export BONZI_BUDDY_DIR="$SCRIPT_DIR"
source "\$BONZI_BUDDY_DIR/zsh_setup.sh"

# Enable tab completion
fpath=(\$BONZI_BUDDY_DIR \$fpath)
autoload -Uz compinit && compinit
EOF
        echo -e "${GREEN}Bonzi Buddy has been added to your .zshrc!${NC}"
        
        # Install zsh completion file
        echo -e "${BLUE}Setting up Zsh completion for subo...${NC}"
        # Create Zsh completions directory if it doesn't exist
        ZSH_COMPLETIONS_DIR="$HOME/.zsh/completions"
        if [ ! -d "$ZSH_COMPLETIONS_DIR" ]; then
            echo -e "${YELLOW}Creating Zsh completions directory...${NC}"
            mkdir -p "$ZSH_COMPLETIONS_DIR"
        fi

        # Set up completion file
        cp "$SCRIPT_DIR/subo_completion.zsh" "$ZSH_COMPLETIONS_DIR/_subo" 2>/dev/null
        cp "$SCRIPT_DIR/subo_completion.zsh" ~/.zsh_completion_setup 2>/dev/null
    fi
    
    # Create command-not-found handler
    echo -e "${BLUE}Setting up command-not-found handler...${NC}"
    if [[ ! -d ~/.oh-my-zsh/functions ]]; then
        mkdir -p ~/.oh-my-zsh/functions
    fi
    
    # Create a function file for the handler if using oh-my-zsh
    if [[ -d ~/.oh-my-zsh ]]; then
        cat << EOF > ~/.oh-my-zsh/functions/command_not_found_handler
#!/bin/zsh
# Bonzi Buddy Command Not Found Handler
"$SCRIPT_DIR/command_not_found.sh" "\$@"
EOF
        chmod +x ~/.oh-my-zsh/functions/command_not_found_handler
    fi
    
else
    # For non-Zsh shells, we just create a warning file
    echo -e "${YELLOW}Setting up minimal components...${NC}"
    
    # Create a simple note in user's home directory
    cat << EOF > ~/.bonzi-buddy-note.txt
Bonzi Buddy Note
================

You attempted to install Bonzi Buddy while using a non-supported shell (${CURRENT_SHELL}).
Bonzi Buddy currently only fully supports Zsh.

To use Bonzi Buddy:
1. Install Zsh: sudo apt install zsh (or equivalent for your distro)
2. Make it your default shell: chsh -s /bin/zsh
3. Log out and log back in
4. Run the Bonzi Buddy installer again

Want to help? Check out the Contributing section in the README to
add support for ${CURRENT_SHELL}!

Visit: https://github.com/abildma/bonzi-buddy-terminal-assistant
EOF
    
    echo -e "${BLUE}Created instructions at ~/.bonzi-buddy-note.txt${NC}"
    echo -e "${YELLOW}Some components were installed, but full functionality requires Zsh.${NC}"
fi

# Create aliases
echo -e "${BLUE}Creating aliases...${NC}"
echo "alias bonzi='$SCRIPT_DIR/bonzi.sh'" > "$SCRIPT_DIR/bonzi.aliases"

# Clean up any temporary files if they exist
rm -f ~/.subo-completion.zsh 2>/dev/null
rm -f ~/.subo-activate.zsh 2>/dev/null

# Final installation message
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    # Export BONZI_BUDDY_DIR for immediate use (without requiring a restart)
    echo -e "${BLUE}Making Bonzi Buddy available in current shell...${NC}"
    export BONZI_BUDDY_DIR="$SCRIPT_DIR"

    # Force update PATH to include ~/bin if it exists
    if [ -d "$HOME/bin" ]; then
        export PATH="$HOME/bin:$PATH"
    fi

    # Setup is complete! User information
    echo ""
    echo -e "${BRIGHT_GREEN}Installation complete!${NC}"
    echo -e "${YELLOW}Bonzi Buddy has been successfully installed on your system.${NC}"
    echo -e "${CYAN}The installation has activated Bonzi Buddy in your current shell.${NC}"
    echo -e "${BLUE}You can start using ${BRIGHT_PURPLE}subo${BLUE} command right away.${NC}"
    echo ""
    echo -e "${YELLOW}Try it now with: ${BRIGHT_GREEN}subo apt update${NC}"
    echo ""
    echo -e "${BLUE}For best experience, restart your shell with:${NC}"
    echo -e "${BRIGHT_PURPLE}exec zsh${NC}"
    echo ""
    echo -e "${GRAY}If you ever want to uninstall Bonzi Buddy, simply run:${NC}"
    echo -e "${YELLOW}$SCRIPT_DIR/uninstall.sh${NC}"
    echo ""
    echo -e "${GREEN}You can use these commands and features:${NC}"
    echo -e "  ${GREEN}bonzi${NC} [command] - Check for typos in any command"
    echo -e "  ${GREEN}subo${NC} [command]  - Run a command with sudo and typo-checking"
    echo -e "  ${CYAN}Missing commands${NC} will automatically be detected and corrected"
    echo -e "  ${CYAN}Command explanations${NC} will help you understand what commands do"
    echo ""
    echo -e "${BLUE}Made a mistake?${NC} You can restore your original configuration with:"
    echo -e "${YELLOW}cp ~/.zshrc.backup.bonzi ~/.zshrc${NC}"
    echo ""
    echo -e "${PURPLE}Enjoy your typo-free terminal experience with Bonzi Buddy!${NC}"
else
    echo ""
    echo -e "${YELLOW}Bonzi Buddy installation completed with limited functionality.${NC}"
    echo -e "${BLUE}For full functionality, please:${NC}"
    echo -e "  1. Install Zsh: ${GREEN}sudo apt install zsh${NC} (or equivalent for your distro)"
    echo -e "  2. Make it your default shell: ${GREEN}chsh -s /bin/zsh${NC}"
    echo -e "  3. Log out and back in, then run the installer again"
    echo ""
    echo -e "${BLUE}See ~/.bonzi-buddy-note.txt for more information.${NC}"
    echo -e "${BLUE}Want to contribute? Check out the Contributing section in the README!${NC}"
fi
