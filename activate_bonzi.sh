#!/bin/bash
# Standalone script to activate Bonzi Buddy in the current terminal session
# This script can be sourced directly without modifying .zshrc
# Usage: source ./activate_bonzi.sh

# ANSI Color codes for pretty output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}Activating Bonzi Buddy...${NC}"

# Get the directory where this script is located
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
else
    # If BASH_SOURCE is not available (Zsh), use $0 instead
    SCRIPT_DIR="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
fi

# Set the BONZI_BUDDY_DIR environment variable
export BONZI_BUDDY_DIR="$SCRIPT_DIR"
echo -e "${BLUE}Set BONZI_BUDDY_DIR to: ${CYAN}$BONZI_BUDDY_DIR${NC}"

# Make sure ~/bin exists and is in PATH
if [ ! -d ~/bin ]; then
    echo -e "${YELLOW}Creating ~/bin directory...${NC}"
    mkdir -p ~/bin
fi

# Add ~/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo -e "${YELLOW}Adding ~/bin to your PATH...${NC}"
    export PATH="$HOME/bin:$PATH"
fi

# Create symbolic links for the commands
echo -e "${BLUE}Creating command links in ~/bin...${NC}"
ln -sf "$SCRIPT_DIR/subo-wrapper" ~/bin/subo
ln -sf "$SCRIPT_DIR/bonzi-wrapper" ~/bin/bonzi
chmod +x "$SCRIPT_DIR/subo-wrapper" "$SCRIPT_DIR/bonzi-wrapper" 2>/dev/null

# Define the command_not_found_handler function directly
command_not_found_handler() {
    "$BONZI_BUDDY_DIR/command_not_found.sh" "$@"
    return $?
}

# Simple compatibility-focused completion setup
echo -e "${BLUE}Setting up simplified tab completion for commands...${NC}"

# Source the simpler completion script
if [ -f "$SCRIPT_DIR/simple_subo_completion.sh" ]; then
    source "$SCRIPT_DIR/simple_subo_completion.sh"
    
    # Set up a basic completion function for Zsh
    if [ -n "$ZSH_VERSION" ]; then
        # Define a simpler completion function for Zsh
        _subo_basic_completion() {
            local cmd="$1"
            local subcmd="$2"
            local cur="$3"
            
            if [[ -z "$cmd" || "$cmd" = "subo" ]]; then
                # First level completion
                reply=(apt apt-get systemctl service docker cp mv rm nano vim cat less grep find)
                return 0
            elif [[ "$cmd" = "apt" ]]; then
                # Second level completion for apt
                reply=(update upgrade install remove purge autoremove dist-upgrade full-upgrade list search show clean autoclean)
                return 0
            fi
            
            # Default to files
            _files
        }
        
        # Register with Zsh
        compdef _subo_basic_completion subo
        
        echo -e "${GREEN}Basic tab completion for subo is enabled.${NC}"
    elif [ -n "$BASH_VERSION" ]; then
        # Bash completion was already set up in the sourced script
        echo -e "${GREEN}Bash tab completion for subo is enabled.${NC}"
    else
        echo -e "${YELLOW}Unknown shell type. Tab completion might not work.${NC}"
    fi
else
    echo -e "${YELLOW}Could not find simple_subo_completion.sh. Tab completion will not work.${NC}"
fi

echo -e "${GREEN}Bonzi Buddy has been activated for this terminal session!${NC}"
echo -e "${CYAN}You can now use the ${YELLOW}subo${CYAN} and ${YELLOW}bonzi${CYAN} commands.${NC}"
echo -e "${BLUE}Also, command-not-found handling is active.${NC}"
echo ""
echo -e "${YELLOW}Note: This activation is temporary for this terminal session only.${NC}"
echo -e "${YELLOW}To make it permanent, run the full installer: ${GREEN}./install.sh${NC}"
