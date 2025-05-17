#!/usr/bin/env bash
# Bash completion for subo command

# This function will call the completion function for sudo
_subo() {
    local cur prev words cword split
    # Use the bash-completion system's helper functions
    _init_completion || return

    # Call the sudo completion function with modified arguments
    # to make it think we're completing for sudo
    words[0]=sudo
    COMP_WORDS[0]=sudo
    _sudo
}

# Register the completion function for subo
complete -F _subo subo
