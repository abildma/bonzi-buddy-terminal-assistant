#!/bin/bash
# Bonzi Buddy - Standalone Version
# This script runs Bonzi Buddy without any shell integration
# Usage: source ./standalone.sh

# Colors for output
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${PURPLE}Bonzi Buddy - Standalone Mode${NC}"
echo -e "${YELLOW}This script activates Bonzi Buddy without modifying your system.${NC}"

# Determine script location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )"
echo -e "${BLUE}Script location: ${SCRIPT_DIR}${NC}"

# Create the bonzi function
bonzi() {
    local cmd="$1"
    shift
    local args="$@"
    
    # Function to suggest correction
    suggest_correction() {
        local cmd="$1"
        case "$cmd" in
            "sl") echo "ls" ;;
            "mr") echo "rm" ;;
            "msdir") echo "mkdir" ;;
            "cd..") echo "cd .." ;;
            "cta") echo "cat" ;;
            "sudp") echo "sudo" ;;
            "suod") echo "sudo" ;;
            "ll") echo "ls -l" ;;
            "la") echo "ls -a" ;;
            "lsa") echo "ls -a" ;;
            "lsal"|"lsla") echo "ls -la" ;;
            "lsl") echo "ls -l" ;;
            "gerp") echo "grep" ;;
            "apt-get"|"apt-gt") echo "apt" ;;
            "atp"|"pa") echo "apt" ;;
            "agt") echo "apt" ;;
            "apt opdate"|"apt-update") echo "apt update" ;;
            "apt updte"|"apt upate"|"apt updae") echo "apt update" ;;
            "apt opgrade"|"apt-upgrade") echo "apt upgrade" ;;
            "apt upgrde"|"apt upgade"|"apt upgrad") echo "apt upgrade" ;;
            *) echo "" ;;
        esac
    }
    
    # Function to get command explanation
    get_explanation() {
        local cmd="$1"
        case "$cmd" in
            ls) echo "List directory contents" ;;
            cd) echo "Change directory" ;;
            cp) echo "Copy files and directories" ;;
            mv) echo "Move/rename files and directories" ;;
            rm) echo "Remove files or directories" ;;
            mkdir) echo "Create directories" ;;
            apt) echo "Advanced package tool for Debian/Ubuntu" ;;
            "apt update") echo "Update list of available packages" ;;
            "apt upgrade") echo "Upgrade the installed packages" ;;
            *) echo "" ;;
        esac
    }
    
    # Get suggestion
    local suggestion=$(suggest_correction "$cmd")
    
    if [ -n "$suggestion" ]; then
        echo -e "${PURPLE}Bonzi Buddy suggests:${NC}"
        echo -e "    ${YELLOW}[ Did you mean: ${GREEN}$suggestion${YELLOW}? ]${NC}"
        
        # Show explanation if available
        local explanation=$(get_explanation "$suggestion")
        if [ -n "$explanation" ]; then
            echo -e "ℹ️   ${CYAN}$suggestion - $explanation${NC}"
        fi
        
        read -p "Would you like to run the suggested command? (Y/n): " choice
        if [[ "$choice" != "n" && "$choice" != "N" ]]; then
            echo -e "Running: ${GREEN}$suggestion $args${NC}"
            eval "$suggestion $args"
        fi
    else
        # No suggestion found, run the command as-is
        eval "$cmd $args"
    fi
}

# Create the subo function
subo() {
    local cmd="$1"
    shift
    local args="$@"
    
    # Function to suggest correction (specific to apt)
    suggest_apt_correction() {
        local cmd="$1"
        case "$cmd" in
            "opdate"|"updte"|"upate"|"updae") echo "update" ;;
            "opgrade"|"upgrde"|"upgade"|"upgrad"|"upgrae") echo "upgrade" ;;
            "isntall"|"instal"|"intall") echo "install" ;;
            "remov"|"rmove"|"reove") echo "remove" ;;
            "sarch"|"serch"|"seach") echo "search" ;;
            *) echo "" ;;
        esac
    }
    
    # For apt commands, check for typos in the subcommand
    if [ "$cmd" == "apt" ] && [ -n "$1" ]; then
        local subcmd="$1"
        local suggestion=$(suggest_apt_correction "$subcmd")
        
        if [ -n "$suggestion" ]; then
            shift  # Remove the incorrect subcommand
            echo -e "${PURPLE}Subo: Running command with sudo${NC}"
            echo -e "    ${YELLOW}[ Did you mean: apt $suggestion? ]${NC}"
            echo -e "ℹ️   ${CYAN}apt - Advanced package tool for Debian/Ubuntu${NC}"
            
            read -p "Would you like to try the suggested command? (Y/n): " choice
            if [[ "$choice" != "n" && "$choice" != "N" ]]; then
                echo -e "Running: ${GREEN}sudo apt $suggestion $args${NC}"
                sudo apt "$suggestion" "$@"
                return
            fi
        fi
    fi
    
    # Default behavior: run with sudo
    echo -e "${PURPLE}Subo: Running command with sudo${NC}"
    echo -e "Running: ${GREEN}sudo $cmd $args${NC}"
    sudo "$cmd" "$@"
}

# Create a simple command-not-found handler
lsl() { ls -l; }
lsa() { ls -a; }
lsla() { ls -la; }
lsal() { ls -la; }
car() { cat "$@"; }
suod() { sudo "$@"; }
sudp() { sudo "$@"; }
sl() { ls; }
maek() { make "$@"; }
mroe() { more "$@"; }
grpe() { grep "$@"; }
greo() { grep "$@"; }
cd..() { cd ..; }

echo -e "${GREEN}Bonzi Buddy loaded successfully in standalone mode!${NC}"
echo -e "${YELLOW}You can now use:${NC}"
echo -e "  ${GREEN}bonzi${NC} <command>  - Check for typos in commands"
echo -e "  ${GREEN}subo${NC} <command>   - Run commands with sudo and typo-checking"
echo ""
echo -e "${BLUE}Common typo corrections are already available:${NC}"
echo -e "  lsl, lsa, lsla, car, suod, cd.., etc."
