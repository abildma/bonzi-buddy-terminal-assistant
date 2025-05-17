#!/bin/bash

# Simple direct fix for Bash users to add Bonzi Buddy functionality

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -e "${BLUE}Fixing Bash support for Bonzi Buddy...${NC}"

# Create a clean setup for Bash with proper syntax
cat > ~/.bonzi_bash_setup << EOF
# Bonzi Buddy - Terminal Assistant setup for Bash

# Command-not-found handler for Bash
# This intercepts commands not found in PATH and runs them through Bonzi Buddy
command_not_found_handle() {
  "$SCRIPT_DIR/command_not_found.sh" "\$@"
  return \$?
}

# Define aliases
alias bonzi="$SCRIPT_DIR/bonzi.sh"

# Set up subo if needed
if [ ! -d ~/bin ]; then
  mkdir -p ~/bin
fi

if [ ! -L ~/bin/subo ]; then
  ln -sf "$SCRIPT_DIR/subo-wrapper" ~/bin/subo
  chmod +x ~/bin/subo
fi

# Add ~/bin to PATH if not already there
if [[ "\$PATH" != *"\$HOME/bin"* ]]; then
  export PATH="\$HOME/bin:\$PATH"
fi

# Load tab completion for subo
source "$SCRIPT_DIR/subo_completion.bash"
EOF

# Clean up any existing Bonzi Buddy sections from .bashrc
if grep -q "Bonzi Buddy" ~/.bashrc; then
    echo -e "${YELLOW}Removing existing Bonzi Buddy setup from .bashrc...${NC}"
    grep -v -e "Bonzi Buddy" -e "BONZI_BUDDY_DIR" -e "command_not_found_handle" -e "bonzi_preexec" ~/.bashrc > ~/.bashrc.temp
    mv ~/.bashrc.temp ~/.bashrc
fi

# Add a simple source line to .bashrc
if ! grep -q "bonzi_bash_setup" ~/.bashrc; then
    echo -e "${BLUE}Adding Bonzi Buddy setup to .bashrc...${NC}"
    echo -e "\n# Bonzi Buddy setup\nsource ~/.bonzi_bash_setup" >> ~/.bashrc
fi

echo -e "${GREEN}Bash setup complete!${NC}"
echo -e "${YELLOW}Please run 'source ~/.bashrc' to activate the changes.${NC}"
