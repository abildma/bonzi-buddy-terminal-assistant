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

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the command explanations
source "$SCRIPT_DIR/command_explanations.sh"

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

if [[ "$COMMAND" =~ apt[[:space:]]+([[:alnum:]\-]+) ]]; then
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
    esac
    
    if [ -n "$suggestion" ]; then
        # Create the corrected command
        CORRECTED="${COMMAND/$typo/$suggestion}"
        
        # Show suggestion
        echo -e "${YELLOW}Bonzi Buddy:${NC} Did you mean: ${GREEN}$suggestion${NC}?"
        
        # Get explanation for the suggested command
        cmd_for_explanation=$(echo "$suggestion" | awk '{print $1}')
        explanation=$(get_command_explanation "$cmd_for_explanation")
        echo -e "${CYAN}ℹ️  $cmd_for_explanation${NC} - $explanation"
        
        read -p "Would you like to try the suggested command? (Y/n): " CONFIRM
        
        if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
            echo -e "${BLUE}Bonzi Buddy:${NC} Running original command: ${GREEN}sudo $COMMAND${NC}"
            sudo $COMMAND
        else
            echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}sudo $CORRECTED${NC}"
            sudo $CORRECTED
        fi
    else
        # No suggestion, just run the command
        echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}sudo $COMMAND${NC}"
        sudo $COMMAND
    fi
else
    # Not an apt command, just run it
    echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}sudo $COMMAND${NC}"
    sudo $COMMAND
fi
