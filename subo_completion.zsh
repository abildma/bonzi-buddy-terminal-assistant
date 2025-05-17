#compdef subo
# Zsh completion for subo command

# Use the existing sudo completion for subo
_sudo_complete() {
  # Create a local copy of the arguments and replace subo with sudo
  local -a words
  words=(sudo "${words[@]:1}")
  
  # Set the command name to sudo for completion
  (( CURRENT = CURRENT ))
  
  # Call the sudo completion function
  _sudo
}

# Register the completion function
_subo() { _sudo_complete "$@" }
compdef _subo subo
