#!/bin/zsh

# Subo - A simple script to run commands with sudo and catch typos
# Usage: subo command [args]
# Example: subo apt update

# Enhanced color palette for a more appealing appearance
GREEN='\033[0;32m'       # Success, commands
BRIGHT_GREEN='\033[1;32m' # Highlighted commands
YELLOW='\033[1;33m'      # Warnings, suggestions
BLUE='\033[0;34m'        # Information
LIGHT_BLUE='\033[0;94m'  # Secondary information
CYAN='\033[0;36m'        # Command descriptions
MAGENTA='\033[0;35m'     # Command highlights
PURPLE='\033[0;35m'      # Bonzi branding
BRIGHT_PURPLE='\033[1;35m' # Enhanced branding
RED='\033[0;31m'         # Errors
GRAY='\033[0;90m'        # Subtle information
WHITE='\033[1;37m'       # Highlighted text
BOLD='\033[1m'           # Bold text
UNDERLINE='\033[4m'      # Underlined text
NC='\033[0m'             # No Color (reset)

# Get the directory of this script - Zsh compatible version
# First try BASH_SOURCE for backward compatibility
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
else
    # If BASH_SOURCE is not available (Zsh), use $0 instead
    SCRIPT_DIR="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
fi

# Source the command explanations
if [ -f "$SCRIPT_DIR/command_explanations.sh" ]; then
    source "$SCRIPT_DIR/command_explanations.sh"
else
    # Define a simple fallback explanation function
    get_command_explanation() {
        local cmd=$1
        case "$cmd" in
            "ls") echo "Lists directory contents" ;;
            "cd") echo "Change directory" ;;
            "mkdir") echo "Make directory" ;;
            "rm") echo "Remove files or directories" ;;
            "cp") echo "Copy files or directories" ;;
            "mv") echo "Move files or directories" ;;
            "cat") echo "Display file contents" ;;
            "grep") echo "Search for patterns in files" ;;
            "find") echo "Search for files in a directory hierarchy" ;;
            "apt") echo "Advanced package tool for Debian/Ubuntu" ;;
            "apt-get") echo "Package manager for Debian/Ubuntu" ;;
            "yum") echo "Package manager for RHEL/CentOS/Fedora" ;;
            "dnf") echo "Package manager for Fedora" ;;
            "pacman") echo "Package manager for Arch Linux" ;;
            "ping") echo "Test network connectivity" ;;
            "ssh") echo "Secure shell remote login" ;;
            "scp") echo "Secure copy files between hosts" ;;
            *) echo "Command details not available" ;;
        esac
    }
fi

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Subo:${NC} Please provide a command to run with sudo."
    echo "Usage: subo command [args]"
    echo "Example: subo apt update"
    exit 1
fi

# Display an enhanced welcome message
echo -e "${BRIGHT_PURPLE}Subo:${NC} ${GRAY}Running command with${NC} ${BRIGHT_GREEN}sudo${NC}"

# Check for typos in the command if it's an apt command
if [[ "$1" == "apt" && $# -ge 2 ]]; then
    # Get the apt subcommand (second argument)
    apt_cmd="$2"
    
    # Check for common typos in apt subcommands
    typo=""
    suggestion=""
    corrected_args=()
    
    # Copy the first argument (apt)
    corrected_args+=("$1")
    
    case "$apt_cmd" in
        # Common apt update typos
        "updote"|"updat"|"upadte"|"opdate"|"uppdate"|"updte"|"updaet"|"updae"|"updete"|"updait"|"upate"|"upd"|"update-") 
            typo="$apt_cmd"
            suggestion="update"
            corrected_args+=("update")
            ;;
        
        # apt upgrade typos
        "upgrad"|"upgrage"|"upgrde"|"upgarde"|"uprgade"|"uppgrade"|"upgread"|"upgrdae"|"upgad"|"upgrade-"|"opgrade") 
            typo="$apt_cmd"
            suggestion="upgrade"
            corrected_args+=("upgrade")
            ;;
        
        # apt install typos
        "instlal"|"instal"|"instll"|"insatll"|"isntall"|"intsall"|"instaall"|"intsall"|"isntall"|"isntal"|"innstall"|"installl"|"nistall"|"install-"|"instael") 
            typo="$apt_cmd"
            suggestion="install"
            corrected_args+=("install")
            ;;
        
        # apt remove typos
        "remov"|"remeve"|"removr"|"reomve"|"rmove"|"removee"|"romove"|"remove-") 
            typo="$apt_cmd"
            suggestion="remove"
            corrected_args+=("remove")
            ;;
            
        # No typo detected, use as-is
        *)
            corrected_args+=("$apt_cmd")
            ;;
    esac
    
    # Add any remaining arguments
    if [ $# -gt 2 ]; then
        for ((i=3; i<=$#; i++)); do
            corrected_args+=("${!i}")
        done
    fi
    
    # If we found a typo, show suggestion
    if [ -n "$typo" ]; then
        # Format the corrected command for display
        corrected_cmd=""
        for arg in "${corrected_args[@]}"; do
            corrected_cmd="$corrected_cmd $arg"
        done
        corrected_cmd=$(echo "$corrected_cmd" | sed 's/^ //')
        
        # Simple bracketed style that works reliably across all terminals
        echo -e "    ${YELLOW}[${NC} ${CYAN}Did you mean:${NC} ${BRIGHT_GREEN}$corrected_cmd${NC}${GRAY}?${NC} ${YELLOW}]${NC}"
        
        # Get explanation for apt with enhanced styling
        explanation=$(get_command_explanation "apt")
        echo -e "${CYAN}ℹ️  ${BOLD}apt${NC} ${GRAY}-${NC} ${LIGHT_BLUE}$explanation${NC}"
        
        echo -n "Would you like to try the suggested command? (Y/n): "
        read CONFIRM
        
        if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
            # Run original command with all arguments
            echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}sudo $@${NC}"
            exec sudo "$@"
        else
            # Run corrected command
            echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}sudo $corrected_cmd${NC}"
            exec sudo "${corrected_args[@]}"
        fi
    else
        # No typo, run command as-is
        echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}sudo $@${NC}"
        exec sudo "$@"
    fi
else
    # Not an apt command or not enough arguments, run as-is
    echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}sudo $@${NC}"
    exec sudo "$@"
fi
