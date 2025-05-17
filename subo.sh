#!/bin/zsh

# Subo - A simple script to run commands with sudo and catch typos
# Usage: subo command [args]
# Example: subo apt update

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

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
            "apt") echo "Package manager for Debian/Ubuntu" ;;
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

# Function to suggest corrections for common command typos
suggest_correction() {
    local cmd="$1"
    local typo=""
    local suggestion=""
    
    # Check for apt command typos
    if [[ "$cmd" =~ apt[[:space:]]+([[:alnum:]\-]+) ]]; then
        typo=${BASH_REMATCH[1]}
        
        case "$typo" in
            # Common apt update typos
            "updote"|"updat"|"upadte"|"opdate"|"uppdate"|"updte"|"updaet"|"updae"|"updete"|"updait"|"upate"|"upd"|"update-") 
                suggestion="update";;
            
            # apt upgrade typos
            "upgrad"|"upgrage"|"upgrde"|"upgarde"|"uprgade"|"uppgrade"|"upgread"|"upgrdae"|"upgad"|"upgrade-"|"opgrade") 
                suggestion="upgrade";;
            
            # apt install typos
            "instlal"|"instal"|"instll"|"insatll"|"isntall"|"intsall"|"instaall"|"intsall"|"isntall"|"isntal"|"innstall"|"installl"|"nistall"|"install-") 
                suggestion="install";;
            
            # apt remove typos
            "remov"|"remeve"|"removr"|"reomve"|"rmove"|"removee"|"romove"|"remove-") 
                suggestion="remove";;
                
            # Other apt commands with typos...
            *) suggestion="";;
        esac
        
        if [ -n "$suggestion" ]; then
            return 0
        fi
    fi
    
    return 1  # No suggestion
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Subo:${NC} Please provide a command to run with sudo."
    echo "Usage: subo command [args]"
    echo "Example: subo apt update"
    exit 1
fi

# Create the full command string
COMMAND="$*"

# Display a welcome message
echo -e "${PURPLE}Subo:${NC} Running command with ${GREEN}sudo${NC}"

# Check for typos in the command
typo=""
suggestion=""
corrected_command=""

# Parse the command properly
if [[ "$1" == "apt" && $# -ge 2 ]]; then
    # Get the apt subcommand (second argument)
    apt_cmd="$2"
    
    # Check for common typos in apt subcommands
    case "$apt_cmd" in
        # Common apt update typos
        "updote"|"updat"|"upadte"|"opdate"|"uppdate"|"updte"|"updaet"|"updae"|"updete"|"updait"|"upate"|"upd"|"update-") 
            typo="$apt_cmd"
            suggestion="update";;
        
        # apt upgrade typos
        "upgrad"|"upgrage"|"upgrde"|"upgarde"|"uprgade"|"uppgrade"|"upgread"|"upgrdae"|"upgad"|"upgrade-"|"opgrade") 
            typo="$apt_cmd"
            suggestion="upgrade";;
        
        # apt install typos
        "instlal"|"instal"|"instll"|"insatll"|"isntall"|"intsall"|"instaall"|"intsall"|"isntall"|"isntal"|"innstall"|"installl"|"nistall"|"install-"|"instael") 
            typo="$apt_cmd"
            suggestion="install";;
        
        # apt remove typos
        "remov"|"remeve"|"removr"|"reomve"|"rmove"|"removee"|"romove"|"remove-") 
            typo="$apt_cmd"
            suggestion="remove";;
    esac
    
    # If a typo was found, construct the corrected command
    if [ -n "$suggestion" ]; then
        # Get any remaining arguments
        remaining_args=""
        if [ $# -gt 2 ]; then
            remaining_args=" ${@:3}"
        fi
        corrected_command="apt $suggestion$remaining_args"
        
        # Show suggestion with the bracket style
        echo -e ""
        echo -e "    ${YELLOW}[${NC} Did you mean: ${GREEN}$corrected_command${NC} ${YELLOW}]${NC}"
        
        # Get explanation for the suggested command
        explanation=$(get_command_explanation "apt")
        echo -e "${CYAN}ℹ️  apt${NC} - $explanation"
        
        echo -n "Would you like to try the suggested command? (Y/n): "
        read CONFIRM
        
        if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
            echo -e "${BLUE}Running:${NC} ${GREEN}sudo $COMMAND${NC}"
            sudo $COMMAND
        else
            echo -e "${BLUE}Running:${NC} ${GREEN}sudo $corrected_command${NC}"
            sudo $corrected_command
        fi
    else
        # No suggestion, just run the command
        echo -e "${BLUE}Running:${NC} ${GREEN}sudo $COMMAND${NC}"
        sudo $COMMAND
    fi
else
    # Not an apt command, just run it
    echo -e "${BLUE}Running:${NC} ${GREEN}sudo $COMMAND${NC}"
    sudo $COMMAND
fi
