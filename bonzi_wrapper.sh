#!/bin/bash

# Bonzi Buddy Shell Wrapper
# This script intercepts all commands before execution to check for typos

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# First, handle the command-not-found case
command_not_found_handler() {
  "$SCRIPT_DIR/bonzi.sh" "$@"
  return $?
}

# Pre-command hook to check for common typos in command arguments
bonzi_preexec() {
  local cmd="$1"
  
  # Skip if empty or if it's already a bonzi command
  if [[ -z "$cmd" || "$cmd" == *"bonzi"* || "$cmd" == *"subo"* ]]; then
    return
  fi
  
  # Common apt command typos
  if [[ "$cmd" == *"apt"*" upgrad"* && "$cmd" != *"apt upgrade"* ]]; then
    echo -e "${PURPLE}Bonzi Buddy${NC} detected a potential typo..."
    echo -e "${YELLOW}Bonzi Buddy:${NC} Did you mean: ${GREEN}apt upgrade${NC}?"
    read -p "Would you like to try the suggested command? (Y/n): " CONFIRM
    
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
      # User wants to keep the original command
      eval "$cmd"
    else
      # User wants the correction - replace upgrad with upgrade
      corrected="${cmd//upgrad/upgrade}"
      echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}$corrected${NC}"
      eval "$corrected"
    fi
    
    # Return to prevent the original command from running
    return 1
  fi
  
  # Add more specific command argument typo patterns here
  
  # If no typos found, just run the original command
  return 0
}

# Export the handler for bash/zsh integration
export -f command_not_found_handler
export -f bonzi_preexec
