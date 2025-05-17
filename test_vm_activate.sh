#!/bin/bash
# Ultra-simplified activation script for test VMs
# Usage: source ./test_vm_activate.sh

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${MAGENTA}Activating Bonzi Buddy (Test VM Mode)...${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )"
echo -e "${BLUE}Script location: ${SCRIPT_DIR}${NC}"

# Set the environment variable
export BONZI_BUDDY_DIR="$SCRIPT_DIR"

# Make sure the scripts are executable
chmod +x "$SCRIPT_DIR/bonzi.sh" "$SCRIPT_DIR/subo.sh" "$SCRIPT_DIR/command_not_found.sh" 2>/dev/null

# Create direct function wrappers
subo() {
  "$SCRIPT_DIR/subo.sh" "$@"
}

bonzi() {
  "$SCRIPT_DIR/bonzi.sh" "$@"
}

command_not_found_handler() {
  "$SCRIPT_DIR/command_not_found.sh" "$@"
  return $?
}

export -f subo bonzi command_not_found_handler 2>/dev/null

echo -e "${GREEN}Bonzi Buddy activated in test VM mode!${NC}"
echo -e "${YELLOW}The ${GREEN}subo${YELLOW} and ${GREEN}bonzi${YELLOW} commands should now work directly.${NC}"
echo -e "${BLUE}No tab completion, but core functionality will work.${NC}"
