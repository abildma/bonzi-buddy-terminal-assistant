#!/bin/bash
# Simple completion script for subo that should work on most systems

# Basic completion function for subo
_subo_completion() {
  # Get the current command line
  local current="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # If it's apt-related, provide apt completions
  if [[ "$prev" == "apt" ]]; then
    COMPREPLY=($(compgen -W "update upgrade install remove purge autoremove dist-upgrade full-upgrade list search show clean autoclean" -- "$current"))
    return 0
  fi
  
  # First argument completions (common commands to use with sudo)
  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=($(compgen -W "apt apt-get systemctl service docker cp mv rm nano vim cat less grep find" -- "$current"))
    return 0
  fi
  
  # Otherwise, default to filenames for completion
  COMPREPLY=($(compgen -f -- "$current"))
  return 0
}

# Register the completion function if we're in bash
if [ -n "$BASH_VERSION" ]; then
  complete -F _subo_completion subo
fi

# For zsh, provide a basic function that can be called from our wrapper
_subo_simple_completion() {
  # Simple apt subcommand completions
  if [[ "$1" == "apt" ]]; then
    echo "update upgrade install remove purge autoremove dist-upgrade full-upgrade list search show clean autoclean"
    return 0
  fi
  
  # First level command suggestions
  echo "apt apt-get systemctl service docker cp mv rm nano vim cat less grep find"
  return 0
}
