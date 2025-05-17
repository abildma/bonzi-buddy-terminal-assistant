#!/bin/zsh

# Bonzi Buddy COMPLETE REMOVAL Script (Nuclear Option)
# This script will THOROUGHLY remove ALL Bonzi Buddy components from your system
# Including all traces in configuration files

# Enhanced color palette
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BRIGHT_PURPLE='\033[1;35m'
NC='\033[0m'

echo -e "${BRIGHT_PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BRIGHT_PURPLE}║             BONZI BUDDY COMPLETE REMOVAL TOOL              ║${NC}"
echo -e "${BRIGHT_PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${YELLOW}WARNING: This will completely remove all traces of Bonzi Buddy${NC}"
echo -e "${YELLOW}from your system, including ALL configuration files.${NC}"
echo
echo -e "${RED}This is a nuclear option that may modify your shell configuration.${NC}"
echo

# Ask for confirmation
read -p "Are you absolutely sure you want to proceed? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo -e "${BLUE}Cancelling removal operation.${NC}"
    exit 0
fi

echo
echo -e "${BLUE}Beginning complete removal process...${NC}"
echo

# =============================================
# 1. COMPLETELY REMOVE ALL SHELL FUNCTION DEFINITIONS
# =============================================

echo -e "${BLUE}[1/7] Removing ALL Bonzi Buddy functions from current session...${NC}"

# Create a temporary script to unset all Bonzi Buddy related functions
cat << 'EOF' > /tmp/unset_bonzi_functions.zsh
# Unset ALL possible Bonzi Buddy related functions
unfunction command_not_found_handler 2>/dev/null
unfunction bonzi_preexec 2>/dev/null
unfunction _subo_completion 2>/dev/null
unset BONZI_BUDDY_DIR 2>/dev/null
unset -f command_not_found_handler 2>/dev/null
unset -f suggest_correction 2>/dev/null
unset -f get_command_explanation 2>/dev/null
unset -f bonzi_preexec 2>/dev/null
echo "Unset all Bonzi Buddy functions from memory"
EOF

# Source it to run in current shell
source /tmp/unset_bonzi_functions.zsh
rm /tmp/unset_bonzi_functions.zsh

# =============================================
# 2. COMPLETELY CLEAN ALL SHELL CONFIGURATION FILES
# =============================================

echo -e "${BLUE}[2/7] Deep cleaning ALL shell configuration files...${NC}"

# Function to deeply clean a file of ALL Bonzi Buddy related content
deep_clean_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo -e "   ${YELLOW}Cleaning $file...${NC}"
        
        # Create a backup
        cp "$file" "${file}.backup.$(date +%Y%m%d%H%M%S)"
        
        # Remove ALL Bonzi Buddy related lines and sections
        sed -i '/[Bb]onzi/d' "$file"
        sed -i '/command_not_found_handler/d' "$file"
        sed -i '/bonzi_preexec/d' "$file"
        sed -i '/subo/d' "$file"
        sed -i '/BONZI_BUDDY_DIR/d' "$file"
        
        echo -e "   ${GREEN}Cleaned ${file}${NC}"
    fi
}

# Clean all possible configuration files
deep_clean_file ~/.zshrc
deep_clean_file ~/.zshenv
deep_clean_file ~/.zprofile
deep_clean_file ~/.bashrc
deep_clean_file ~/.bash_profile
deep_clean_file ~/.profile

# Additionally, check for any configuration files in common locations
for config_dir in ~/.config/zsh ~/.oh-my-zsh/custom ~/.zshrc.d; do
    if [[ -d "$config_dir" ]]; then
        echo -e "   ${YELLOW}Checking $config_dir for Bonzi Buddy files...${NC}"
        find "$config_dir" -type f -exec grep -l "bonzi\|subo\|command_not_found_handler" {} \; 2>/dev/null | while read file; do
            echo -e "   ${RED}Found Bonzi Buddy in $file${NC}"
            deep_clean_file "$file"
        done
    fi
done

# =============================================
# 3. REMOVE ALL POSSIBLE COMMAND-NOT-FOUND HANDLERS
# =============================================

echo -e "${BLUE}[3/7] Removing ALL command-not-found handlers...${NC}"

# Check common locations for command-not-found handlers
for handler_path in ~/.oh-my-zsh/functions/command_not_found_handler \
                   /usr/local/share/zsh/site-functions/command_not_found_handler \
                   ~/.zsh/functions/command_not_found_handler; do
    if [[ -f "$handler_path" ]]; then
        echo -e "   ${RED}Found handler at $handler_path${NC}"
        rm -f "$handler_path"
        echo -e "   ${GREEN}Removed handler${NC}"
    fi
done

# =============================================
# 4. REMOVE ALL BONZI BUDDY FILES
# =============================================

echo -e "${BLUE}[4/7] Removing ALL Bonzi Buddy files...${NC}"

# Get current directory
SCRIPT_DIR="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"

# Remove all possible Bonzi Buddy files
rm -f ~/.bonzi-buddy-note.txt 2>/dev/null
rm -f ~/bin/subo 2>/dev/null
rm -f ~/.subo-function.zsh ~/.subo-completion.zsh ~/.subo-activate.zsh ~/.zsh_completion_setup 2>/dev/null

# Cleanup any shell completions
for completion_dir in $(zsh -c 'echo -n $fpath' | tr ' ' '\n' | grep -v '^$'); do
    if [[ -d "$completion_dir" ]]; then
        if [[ -f "$completion_dir/_subo" ]]; then
            echo -e "   ${RED}Found _subo completion in $completion_dir${NC}"
            rm -f "$completion_dir/_subo"
            echo -e "   ${GREEN}Removed _subo completion${NC}"
        fi
    fi
done

# =============================================
# 5. SEARCH FOR ANY REMAINING FILES
# =============================================

echo -e "${BLUE}[5/7] Checking for ANY remaining Bonzi Buddy files...${NC}"

# Search in home directory for any remnants
echo -e "   ${YELLOW}Searching for any remaining Bonzi Buddy files...${NC}"
REMAINING_FILES=$(find ~ -type f -name "*bonzi*" 2>/dev/null)

if [[ -n "$REMAINING_FILES" ]]; then
    echo -e "   ${RED}Found remaining files:${NC}"
    echo "$REMAINING_FILES"
    echo -e "   ${YELLOW}You may want to manually remove these files.${NC}"
else
    echo -e "   ${GREEN}No remaining Bonzi Buddy files found.${NC}"
fi

# =============================================
# 6. CHECK FOR ANY REMAINING REFERENCES
# =============================================

echo -e "${BLUE}[6/7] Checking for ANY remaining references in configuration...${NC}"

# Use grep to find any remaining references
REMAINING_REFS=$(grep -r "bonzi\|subo\|command_not_found_handler" ~ --include=".*" 2>/dev/null)

if [[ -n "$REMAINING_REFS" ]]; then
    echo -e "   ${RED}Found remaining references:${NC}"
    echo "$REMAINING_REFS"
    echo -e "   ${YELLOW}You may want to check these files manually.${NC}"
else
    echo -e "   ${GREEN}No remaining references found.${NC}"
fi

# =============================================
# 7. FINAL CLEANUP
# =============================================

echo -e "${BLUE}[7/7] Performing final cleanup...${NC}"

# Remove any functions or variables from current session
unfunction command_not_found_handler 2>/dev/null
unset BONZI_BUDDY_DIR
unset -f bonzi_preexec
unset -f command_not_found_handler

echo -e "${GREEN}Completed all cleanup steps.${NC}"
echo

# =============================================
# SUCCESS MESSAGE
# =============================================

echo -e "${BRIGHT_GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BRIGHT_GREEN}║             BONZI BUDDY REMOVAL COMPLETED                  ║${NC}"
echo -e "${BRIGHT_GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${YELLOW}Bonzi Buddy has been completely removed from your system.${NC}"
echo -e "${YELLOW}To apply these changes, please restart your terminal or run:${NC}"
echo
echo -e "   ${BRIGHT_PURPLE}exec zsh${NC}"
echo
echo -e "${BLUE}Thank you for trying Bonzi Buddy. Goodbye!${NC}"
