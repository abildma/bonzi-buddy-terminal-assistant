#!/bin/bash

# Setup file for Zsh shell integration with Bonzi Buddy

# Get the directory of this setup script
BONZI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Add Bonzi Buddy integration to the user's .zshrc
cat << EOF >> ~/.zshrc

# Bonzi Buddy Integration

# Command Not Found Handler
command_not_found_handler() {
  "$BONZI_DIR/command_not_found.sh" "\$@"
  return \$?
}

# Bonzi Buddy Command Correction Function (to be used in preexec hook)
bonzi_correct_command() {
  local cmd="$1"
  local needs_sudo=false
  local corrected=""
  
  # Skip if empty or if it's already a bonzi command
  if [[ -z "$cmd" || "$cmd" == *"bonzi"* || "$cmd" == *"subo"* ]]; then
    return 0
  fi
  
  # Check if this looks like an apt command that might need sudo
  if [[ "$cmd" == "apt"* && "$cmd" != "sudo apt"* ]]; then
    needs_sudo=true
  fi
  
  # Check for apt upgrad typo
  if [[ "$cmd" == *"apt"*" upgrad"* && "$cmd" != *"apt upgrade"* ]]; then
    corrected="${cmd//upgrad/upgrade}"
    
    echo ""
    echo "\033[0;35mBonzi Buddy\033[0m detected a potential typo..."
    
    # Show if sudo is going to be added
    if [[ "$needs_sudo" == true && "$cmd" != "sudo"* ]]; then
      echo "\033[1;33mBonzi Buddy:\033[0m Did you mean: \033[0;32msudo $corrected\033[0m?"
      read -p "Would you like to try the suggested command? (Y/n): " CONFIRM
      
      if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
        # User wants to keep the original command
        echo "\033[0;34mBonzi Buddy:\033[0m Running original command: \033[0;32m$cmd\033[0m"
        eval "$cmd"
      else
        # User wants the correction with sudo
        echo "\033[0;34mBonzi Buddy:\033[0m Running: \033[0;32msudo $corrected\033[0m"
        eval "sudo $corrected"
      fi
    else
      # No sudo needed
      echo "\033[1;33mBonzi Buddy:\033[0m Did you mean: \033[0;32m$corrected\033[0m?"
      read -p "Would you like to try the suggested command? (Y/n): " CONFIRM
      
      if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
        # User wants to keep the original command
        echo "\033[0;34mBonzi Buddy:\033[0m Running original command: \033[0;32m$cmd\033[0m"
        eval "$cmd"
      else
        # User wants the correction without sudo
        echo "\033[0;34mBonzi Buddy:\033[0m Running: \033[0;32m$corrected\033[0m"
        eval "$corrected"
      fi
    fi
    
    # Return 1 to indicate we've handled the command
    return 1
  fi
  
  # If we get here, no typos were found
  return 0
}

# Preexec Hook to Catch Typos in Command Arguments
preexec() {
  bonzi_correct_command "$1"
  return $?
}

# Bonzi Buddy sudo alias
alias subo="$BONZI_DIR/subo.sh"
EOF

echo "Zsh configuration added to ~/.zshrc"
echo "Please run 'source ~/.zshrc' or restart your terminal for changes to take effect."
