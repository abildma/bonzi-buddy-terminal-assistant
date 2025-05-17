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

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")
echo -e "${BLUE}Detected shell:${NC} $CURRENT_SHELL"

# Install based on shell type
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
    
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    echo -e "${BLUE}Setting up for Bash...${NC}"
    
    # Create backup of .bashrc if it exists
    if [[ -f ~/.bashrc ]]; then
        echo -e "${YELLOW}Creating backup of your .bashrc file to ~/.bashrc.backup.bonzi${NC}"
        cp ~/.bashrc ~/.bashrc.backup.bonzi
    fi
    
    # Create bin directory in home if it doesn't exist
    if [ ! -d ~/bin ]; then
        echo -e "${YELLOW}Creating ~/bin directory...${NC}"
        mkdir -p ~/bin
    fi
    
    # Add bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo -e "${YELLOW}Adding ~/bin to your PATH...${NC}"
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        # Apply PATH change for the current session
        export PATH="$HOME/bin:$PATH"
    fi
    
    # Install subo wrapper for tab completion
    echo -e "${BLUE}Installing subo wrapper for tab completion...${NC}"
    ln -sf "$SCRIPT_DIR/subo-wrapper" ~/bin/subo
    chmod +x ~/bin/subo
    
    # Create a command-not-found handler directory if it doesn't exist
    if [ ! -d /usr/lib/command-not-found ]; then
        echo -e "${YELLOW}Setting up command-not-found directory...${NC}"
        sudo mkdir -p /usr/lib/command-not-found 2>/dev/null || mkdir -p ~/.local/command-not-found
    fi
    
    # Try to set up the command-not-found handler
    if [ -d /usr/lib/command-not-found ] && [ -w /usr/lib/command-not-found ]; then
        echo -e "${BLUE}Setting up system-wide command-not-found handler...${NC}"
        sudo cp "$SCRIPT_DIR/command_not_found.sh" /usr/lib/command-not-found/bonzi_handler 2>/dev/null
        sudo chmod +x /usr/lib/command-not-found/bonzi_handler 2>/dev/null
    elif [ -d ~/.local/command-not-found ]; then
        echo -e "${BLUE}Setting up user command-not-found handler...${NC}"
        cp "$SCRIPT_DIR/command_not_found.sh" ~/.local/command-not-found/bonzi_handler
        chmod +x ~/.local/command-not-found/bonzi_handler
    fi
    
    # Add Bonzi Buddy to .bashrc
    echo -e "${GREEN}Adding Bonzi Buddy to your .bashrc...${NC}"
    
    # Check if our setup is already in .bashrc
    if grep -q "BONZI_BUDDY_DIR" ~/.bashrc; then
        echo -e "${YELLOW}Bonzi Buddy setup already found in .bashrc. Skipping...${NC}"
    else
        cat << EOF >> ~/.bashrc

# Bonzi Buddy - Terminal Assistant
export BONZI_BUDDY_DIR="$SCRIPT_DIR"
alias bonzi="$SCRIPT_DIR/bonzi.sh"

# Make sure bash-completion is loaded
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Load subo command completion
source "$SCRIPT_DIR/subo_completion.bash"

# Function to handle command not found (used as a fallback)
command_not_found_handle() {
    "$SCRIPT_DIR/command_not_found.sh" "\$@"
    return \$?
}

# Function to check commands before executing
bonzi_preexec() {
    if [[ "\$BASH_COMMAND" != "bonzi_preexec"* && "\$BASH_COMMAND" != "command_not_found_handle"* ]]; then
        "$SCRIPT_DIR/bonzi_wrapper.sh" "\$BASH_COMMAND"
    fi
}
trap 'bonzi_preexec' DEBUG
EOF
        echo -e "${GREEN}Bonzi Buddy has been added to your .bashrc!${NC}"
    fi
    
else
    echo -e "${YELLOW}Unsupported shell: $CURRENT_SHELL${NC}"
    echo -e "You can still use Bonzi Buddy, but you'll need to manually configure it."
    echo -e "Try running: ${GREEN}$SCRIPT_DIR/bonzi.sh [command]${NC}"
fi

# Create aliases
echo -e "${BLUE}Creating aliases...${NC}"
echo "alias bonzi='$SCRIPT_DIR/bonzi.sh'" > "$SCRIPT_DIR/bonzi.aliases"

# Clean up any temporary files if they exist
rm -f ~/.subo-completion.zsh 2>/dev/null
rm -f ~/.subo-activate.zsh 2>/dev/null

# Ask user to reload shell configuration
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}To activate Bonzi Buddy, please run:${NC}"
echo -e "${PURPLE}source ~/.${CURRENT_SHELL}rc${NC}"
echo ""
echo -e "Then you can use these commands:"
echo -e "  ${GREEN}bonzi${NC} [command] - Check for typos in any command"
echo -e "  ${GREEN}subo${NC} [command]  - Run a command with sudo and typo-checking"
echo -e "  ${CYAN}Missing commands${NC} will automatically be detected and corrected"
echo -e "  ${CYAN}Command explanations${NC} will help you understand what commands do"
echo ""
echo -e "${BLUE}Made a mistake?${NC} You can restore your original configuration with:"
echo -e "${YELLOW}cp ~/.${CURRENT_SHELL}rc.backup.bonzi ~/.${CURRENT_SHELL}rc${NC}"
echo ""
echo -e "${PURPLE}Enjoy your typo-free terminal experience with Bonzi Buddy!${NC}"
