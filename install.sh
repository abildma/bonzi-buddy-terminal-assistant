#!/bin/bash

# Colors for friendly messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII art banner
echo -e "${PURPLE}"
cat << "EOF"
 ____                  _    ____            _     _       
| __ )  ___  _ __  ___(_)  | __ ) _   _  __| | __| |_   _ 
|  _ \ / _ \| '_ \/ __|    |  _ \| | | |/ _` |/ _` | | | |
| |_) | (_) | | | \__ \_   | |_) | |_| | (_| | (_| | |_| |
|____/ \___/|_| |_|___(_)  |____/ \__,_|\__,_|\__,_|\__, |
                                                    |___/ 
EOF
echo -e "${NC}"

echo -e "${YELLOW}Welcome to Bonzi Buddy Installation!${NC}"
echo -e "A friendly terminal assistant with ${GREEN}zero spyware${NC}!"
echo -e "${CYAN}Note: Bonzi Buddy currently only supports Zsh${NC}"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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
        echo -e "${YELLOW}Creating backup of your .zshrc file to ~/.zshrc.backup.bonzi${NC}"
        cp ~/.zshrc ~/.zshrc.backup.bonzi
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
    
    # Install subo wrapper for tab completion
    echo -e "${BLUE}Installing subo wrapper for tab completion...${NC}"
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
        echo -e "${BLUE}Setting up zsh tab completion...${NC}"
        ln -sf "$SCRIPT_DIR/subo_completion.zsh" "$SCRIPT_DIR/_subo"
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
    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${YELLOW}To activate Bonzi Buddy, please run:${NC}"
    echo -e "${PURPLE}source ~/.zshrc${NC}"
    echo ""
    echo -e "You can use these commands and features:"
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
