#!/bin/zsh

# Bonzi Buddy Complete Uninstaller Script
# This script will thoroughly remove all Bonzi Buddy components from your system

# Bonzi Buddy Uninstaller Script
# This script will remove all Bonzi Buddy components from your system

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

# ASCII art banner
echo -e "${PURPLE}"
cat << "EOF"
 ____                     _    ____            _     _       
| __ )  ___  _ __  ____ (_)  | __ ) _   _  __| | __| |_   _ 
|  _ \ / _ \| '_ \|_  / | |  |  _ \| | | |/ _` |/ _` | | | |
| |_) | (_) | | | |/ /  | |  | |_) | |_| | (_| | (_| | |_| |
|____/ \___/|_| |_/___| |_|  |____/ \__,_|\__,_|\__,_|\__, |
                                                       |___/ 
EOF
echo -e "${NC}"

echo -e "${YELLOW}Bonzi Buddy Uninstaller${NC}"
echo "This script will remove Bonzi Buddy from your system."
echo ""

# Verify shell is Zsh
CURRENT_SHELL=$(basename "$SHELL")
echo -e "${BLUE}Detected shell:${NC} $CURRENT_SHELL"

if [[ "$CURRENT_SHELL" != "zsh" ]]; then
    echo -e "${YELLOW}Note: Bonzi Buddy is designed for Zsh, but we'll clean up any components.${NC}"
fi

# Remove modifications from shell config files
cleanup_shell_config() {
    local config_file="$1"
    local backup_file="$2"
    
    if [[ -f "$config_file" ]]; then
        echo -e "${BLUE}Cleaning up $config_file...${NC}"
        
        # Create a temporary file without Bonzi Buddy sections
        grep -v "# Bonzi Buddy" "$config_file" | 
        grep -v "BONZI_BUDDY_DIR" | 
        grep -v "bonzi.sh" | 
        grep -v "subo.sh" | 
        grep -v "subo-wrapper" |
        grep -v "subo_completion" |
        grep -v "bonzi_preexec" |
        grep -v "bonzi_wrapper.sh" |
        grep -v "zsh_completion_setup" |
        grep -v "zsh_setup.sh" > /tmp/shell_config_cleaned
        
        # Remove empty lines at the end
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' /tmp/shell_config_cleaned
        
        # Replace the original with cleaned version
        cp /tmp/shell_config_cleaned "$config_file"
        rm /tmp/shell_config_cleaned
        
        echo -e "${GREEN}Cleaned up Bonzi Buddy entries from $config_file${NC}"
    fi
    
    # Restore backup if available
    if [[ -f "$backup_file" ]]; then
        echo -e "${YELLOW}Found backup at $backup_file${NC}"
        read -p "Would you like to restore this backup? (y/N): " RESTORE
        if [[ "$RESTORE" == "y" || "$RESTORE" == "Y" ]]; then
            cp "$backup_file" "$config_file"
            echo -e "${GREEN}Restored $config_file from backup${NC}"
        fi
    fi
}

# Clean up shell config files
cleanup_shell_config ~/.zshrc ~/.zshrc.backup.bonzi

# Properly remove the command-not-found handler from ZSH
echo -e "${BLUE}Removing command-not-found handler from Zsh...${NC}"

# Check for and remove command_not_found_handler from .zshrc
if grep -q "command_not_found_handler" ~/.zshrc; then
    echo -e "${YELLOW}Found command-not-found handler in .zshrc, removing...${NC}"
    # Remove the handler function and any references to it
    sed -i '/command_not_found_handler/d' ~/.zshrc
    echo -e "${GREEN}Removed command-not-found handler from .zshrc${NC}"
fi

# Check for command-not-found handler in zshrc.d or similar locations
for zsh_config_dir in ~/.zshrc.d ~/.oh-my-zsh/custom ~/.config/zsh; do
    if [[ -d "$zsh_config_dir" ]]; then
        echo -e "${BLUE}Checking $zsh_config_dir for Bonzi Buddy files...${NC}"
        for file in "$zsh_config_dir"/*; do
            if grep -q "command_not_found_handler\|bonzi\|Bonzi Buddy" "$file" 2>/dev/null; then
                echo -e "${YELLOW}Removing Bonzi Buddy references from $file${NC}"
                sed -i '/command_not_found_handler\|bonzi\|Bonzi Buddy/d' "$file"
            fi
        done
    fi
done

# If command_not_found_handler is defined in current session, unset it
echo -e "${BLUE}Unsetting command_not_found_handler in current session...${NC}"
cat << 'EOF' > /tmp/bonzi_unset_handler.zsh
# Check if the function is defined
if typeset -f command_not_found_handler > /dev/null; then
    # Unset the function
    unfunction command_not_found_handler
    echo "Command not found handler has been unset"
fi
EOF

# Source the temporary script
source /tmp/bonzi_unset_handler.zsh
rm /tmp/bonzi_unset_handler.zsh

# Also cleanup any Bash files that might have been created by older versions
if [[ -f ~/.bashrc ]]; then
    echo -e "${BLUE}Checking for any Bonzi Buddy entries in .bashrc...${NC}"
    if grep -q "BONZI_BUDDY_DIR\|bonzi.sh" ~/.bashrc; then
        cleanup_shell_config ~/.bashrc ~/.bashrc.backup.bonzi
        echo -e "${GREEN}Removed Bonzi Buddy references from .bashrc${NC}"
    fi
fi

# Remove any note file
if [[ -f ~/.bonzi-buddy-note.txt ]]; then
    echo -e "${BLUE}Removing note file...${NC}"
    rm -f ~/.bonzi-buddy-note.txt
fi

# Remove subo executable from bin
if [[ -f ~/bin/subo ]]; then
    echo -e "${BLUE}Removing subo from ~/bin...${NC}"
    rm -f ~/bin/subo
fi

# Remove temporary files
echo -e "${BLUE}Cleaning up temporary files...${NC}"
rm -f ~/.subo-function.zsh ~/.subo-completion.zsh ~/.subo-activate.zsh ~/.zsh_completion_setup 2>/dev/null

# Get script directory properly (Zsh compatible)
SCRIPT_DIR="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
echo -e "${BLUE}Script directory: $SCRIPT_DIR${NC}"

# Remove symlinks
echo -e "${BLUE}Removing symlinks...${NC}"
if [[ -L "$SCRIPT_DIR/_subo" ]]; then
    rm -f "$SCRIPT_DIR/_subo"
    echo -e "${GREEN}Removed _subo symlink${NC}"
fi

# Check for Bonzi Buddy in the zsh completion path
ZSH_COMPLETION_PATH="$(zsh -c 'echo -n $fpath' | tr ' ' '\n' | grep -v '^$' | head -n 1)"
if [[ -n "$ZSH_COMPLETION_PATH" ]]; then
    echo -e "${BLUE}Checking for Bonzi Buddy completions in $ZSH_COMPLETION_PATH...${NC}"
    if [[ -f "$ZSH_COMPLETION_PATH/_subo" ]]; then
        echo -e "${YELLOW}Removing _subo completion from $ZSH_COMPLETION_PATH${NC}"
        rm -f "$ZSH_COMPLETION_PATH/_subo"
    fi
fi

echo ""
# Verify there are no remaining Bonzi Buddy references in system
echo -e "${BLUE}Checking for any remaining Bonzi Buddy components...${NC}"
REMAINING_REFERENCES=$(grep -r "bonzi\|subo\|command_not_found_handler" ~ --include=".*rc" --include=".*profile" 2>/dev/null)

if [[ -n "$REMAINING_REFERENCES" ]]; then
    echo -e "${YELLOW}Some references to Bonzi Buddy might still exist:${NC}"
    echo "$REMAINING_REFERENCES"
    echo -e "${BLUE}You may want to manually check these files.${NC}"
else
    echo -e "${GREEN}No remaining references found.${NC}"
fi

# Clear any environment variables from the current session
unset BONZI_BUDDY_DIR

# Final clean-up message
echo ""
echo -e "${BRIGHT_GREEN}Uninstallation complete!${NC}"
echo -e "${YELLOW}Bonzi Buddy has been completely removed from your system.${NC}"
echo -e "${CYAN}To ensure all changes take effect, please run:${NC}"
echo -e "${BRIGHT_PURPLE}exec zsh${NC}"
echo ""
echo -e "${BLUE}If you'd like to completely remove the Bonzi Buddy files,${NC}"
echo -e "${BLUE}you can delete this directory with:${NC}"
echo -e "${YELLOW}rm -rf $SCRIPT_DIR${NC}"
echo ""
echo -e "${BRIGHT_PURPLE}Goodbye! We hope you enjoyed using Bonzi Buddy!${NC}"
