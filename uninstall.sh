#!/bin/bash

# Bonzi Buddy Uninstaller Script
# This script will remove all Bonzi Buddy components from your system

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# ASCII art banner
echo -e "${PURPLE}"
cat << "EOF"
 ____                  _    ____            _     _       
| __ )  ___  _ __  ___(_)  | __ ) _   _  __| | __| |_   _ 
|  _ \ / _ \| '_ \/ __|    |  _ \| | | |/ _` |/ _` | | | |
| |_) | (_) | | | \__ \_   | |_) | |_| | (_| | (_| | |_| |
|____/ \___/|_| |_|___(_)  |____/ \__,_|\__,_|\__,_|\__, |
                                                    |___/ 
EOF
echo -e "${NC}"

echo -e "${YELLOW}Bonzi Buddy Uninstaller${NC}"
echo "This script will remove Bonzi Buddy from your system."
echo ""

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")
echo -e "${BLUE}Detected shell:${NC} $CURRENT_SHELL"

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
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    cleanup_shell_config ~/.zshrc ~/.zshrc.backup.bonzi
    
    # Remove command not found handler for zsh
    if [[ -f ~/.oh-my-zsh/functions/command_not_found_handler ]]; then
        echo -e "${BLUE}Removing command-not-found handler...${NC}"
        rm -f ~/.oh-my-zsh/functions/command_not_found_handler
    fi
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    cleanup_shell_config ~/.bashrc ~/.bashrc.backup.bonzi
else
    echo -e "${YELLOW}Unsupported shell: $CURRENT_SHELL${NC}"
    echo -e "You may need to manually remove Bonzi Buddy entries from your shell config file."
fi

# Remove subo executable from bin
if [[ -f ~/bin/subo ]]; then
    echo -e "${BLUE}Removing subo from ~/bin...${NC}"
    rm -f ~/bin/subo
fi

# Remove temporary files
echo -e "${BLUE}Cleaning up temporary files...${NC}"
rm -f ~/.subo-function.zsh ~/.subo-completion.zsh ~/.subo-activate.zsh ~/.zsh_completion_setup 2>/dev/null

# Remove symlinks
echo -e "${BLUE}Removing symlinks...${NC}"
if [[ -L "$SCRIPT_DIR/_subo" ]]; then
    rm -f "$SCRIPT_DIR/_subo"
fi

echo ""
echo -e "${GREEN}Uninstallation complete!${NC}"
echo -e "${YELLOW}Bonzi Buddy has been removed from your system.${NC}"
echo -e "To apply these changes, please restart your terminal or run:"
echo -e "${PURPLE}source ~/.${CURRENT_SHELL}rc${NC}"
echo ""
echo -e "${BLUE}If you'd like to completely remove the Bonzi Buddy files,${NC}"
echo -e "${BLUE}you can delete this directory with:${NC}"
echo -e "${YELLOW}rm -rf $(dirname "$0")${NC}"
echo ""
echo -e "${PURPLE}Goodbye! We hope you enjoyed using Bonzi Buddy!${NC}"
