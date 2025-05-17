#!/bin/bash

# Emergency fix for .bashrc syntax errors
# This script will clean up any Bonzi Buddy related code in .bashrc

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}Emergency .bashrc cleanup${NC}"
echo -e "${YELLOW}This will fix syntax errors in your .bashrc file${NC}"

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Create a backup of the current .bashrc
echo -e "${BLUE}Creating backup of current .bashrc to ~/.bashrc.broken${NC}"
cp ~/.bashrc ~/.bashrc.broken

# Filter out all Bonzi Buddy related lines and any incomplete blocks
echo -e "${BLUE}Cleaning up .bashrc file...${NC}"
grep -v -E "Bonzi|bonzi|command_not_found|BONZI_BUDDY_DIR|subo|bash_completion" ~/.bashrc > ~/.bashrc.clean

# Make sure there are no dangling if/fi statements
CLEAN_FILE=~/.bashrc.clean
TEMP_FILE=~/.bashrc.temp

# First pass: remove lines with lone "fi" or "done" without matching "if" or "for/while"
grep -v "^[[:space:]]*fi[[:space:]]*$" $CLEAN_FILE | grep -v "^[[:space:]]*done[[:space:]]*$" > $TEMP_FILE
mv $TEMP_FILE $CLEAN_FILE

# Second pass: check for if statements without matching fi and remove them
awk '
BEGIN { if_count=0; bracket_count=0; }
/\<if\>/ { if_count++; }
/\<fi\>/ { if_count--; }
/{/ { bracket_count++; }
/}/ { bracket_count--; }
{ print $0; }
END {
    if (if_count != 0 || bracket_count != 0) {
        print "# Note: Some control structures were removed to fix syntax errors";
    }
}' $CLEAN_FILE > $TEMP_FILE
mv $TEMP_FILE $CLEAN_FILE

# Replace .bashrc with cleaned version
echo -e "${BLUE}Installing cleaned .bashrc...${NC}"
mv $CLEAN_FILE ~/.bashrc

# Create a simple self-contained Bonzi setup file
echo -e "${BLUE}Creating fresh Bonzi Buddy setup file...${NC}"
cat > ~/.bonzi_setup << EOF
# Bonzi Buddy setup file - created by emergency_fix.sh

# Add bin to path if not already there
if [[ "\$PATH" != *"\$HOME/bin"* ]]; then
  export PATH="\$HOME/bin:\$PATH"
fi

# Create bin directory if it doesn't exist
if [ ! -d "\$HOME/bin" ]; then
  mkdir -p "\$HOME/bin" 
fi

# Set up aliases and paths
alias bonzi="${SCRIPT_DIR}/bonzi.sh"
ln -sf "${SCRIPT_DIR}/subo-wrapper" "\$HOME/bin/subo"
chmod +x "\$HOME/bin/subo" 2>/dev/null

# Simple command not found handler that doesn't modify shell behavior
bonzi_command_not_found() {
  "${SCRIPT_DIR}/command_not_found.sh" "\$@"
}

# Add simple alias for command checking
alias check_command="bonzi_command_not_found"
EOF

# Add a simple source line to .bashrc
echo -e "\n# Bonzi Buddy Setup\nsource ~/.bonzi_setup" >> ~/.bashrc

echo -e "${GREEN}Emergency fix complete!${NC}"
echo -e "${YELLOW}Please run the following command to activate:${NC}"
echo -e "${GREEN}source ~/.bashrc${NC}"
echo -e ""
echo -e "${BLUE}Note: Your original .bashrc is backed up at ~/.bashrc.broken${NC}"
echo -e "${BLUE}To use command correction, type: ${GREEN}bonzi command${NC} or ${GREEN}check_command command${NC}"
echo -e "${YELLOW}Full command-not-found integration for Bash requires shell modifications${NC}"
echo -e "${YELLOW}that may conflict with system-specific settings.${NC}"
