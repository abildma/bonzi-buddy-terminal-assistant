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

# Ask for confirmation - Zsh compatible version
echo -n "Are you absolutely sure you want to proceed? (yes/no): "
read CONFIRM
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

# Unset all Bonzi Buddy related functions directly (more reliable in Zsh)
echo -e "   ${YELLOW}Attempting to unset all Bonzi functions directly...${NC}"

# Try both Zsh and POSIX ways to unset functions
unfunction command_not_found_handler 2>/dev/null
unfunction bonzi_preexec 2>/dev/null
unfunction _subo_completion 2>/dev/null

# Unset environment variables
unset BONZI_BUDDY_DIR 2>/dev/null

# Backup attempt with unset -f for compatibility
unset -f command_not_found_handler 2>/dev/null
unset -f suggest_correction 2>/dev/null
unset -f get_command_explanation 2>/dev/null
unset -f bonzi_preexec 2>/dev/null

echo -e "   ${GREEN}Unset all Bonzi Buddy functions from memory${NC}"

# =============================================
# 2. COMPLETELY CLEAN ALL SHELL CONFIGURATION FILES
# =============================================

echo -e "${BLUE}[2/7] Deep cleaning ALL shell configuration files...${NC}"

# Function to deeply clean a file of ALL Bonzi Buddy related content
deep_clean_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo -e "   ${YELLOW}Cleaning $file...${NC}"
        
        # Create a backup with timestamp
        BACKUP_FILE="${file}.backup.$(date +%Y%m%d%H%M%S)"
        cp "$file" "$BACKUP_FILE"
        echo -e "   ${GREEN}Created backup: $BACKUP_FILE${NC}"
        
        # Use a safer, more compatible approach for sed in-place editing
        # This approach works on more systems including macOS
        TMP_FILE="${file}.tmp"
        grep -v "[Bb]onzi" "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
        grep -v "command_not_found_handler" "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
        grep -v "bonzi_preexec" "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
        grep -v "subo" "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
        grep -v "BONZI_BUDDY_DIR" "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
        
        echo -e "   ${GREEN}Cleaned ${file}${NC}"
    fi
}

# Clean all possible configuration files
# Clean standard Zsh config files
for config_file in ~/.zshrc ~/.zshenv ~/.zshprofile ~/.zlogin ~/.zlogout; do
    if [[ -f "$config_file" ]]; then
        deep_clean_file "$config_file"
    fi
done

# Also clean standard Bash files in case they were modified by older versions
for bash_file in ~/.bashrc ~/.bash_profile ~/.profile; do
    if [[ -f "$bash_file" ]]; then
        deep_clean_file "$bash_file"
    fi
done

# Additionally, check for any configuration files in common locations
for zsh_config_dir in ~/.zshrc.d ~/.oh-my-zsh/custom ~/.config/zsh; do
    if [[ -d "$zsh_config_dir" ]]; then
        echo -e "   ${BLUE}Checking $zsh_config_dir for Bonzi Buddy files...${NC}"
        BONZI_FILES=$(find "$zsh_config_dir" -type f -exec grep -l "bonzi\|subo\|command_not_found_handler" {} \; 2>/dev/null || echo "")
        
        if [[ -n "$BONZI_FILES" ]]; then
            echo "$BONZI_FILES" | while read -r file; do
                echo -e "   ${RED}Found Bonzi Buddy in $file${NC}"
                deep_clean_file "$file"
            done
        else
            echo -e "   ${GREEN}No Bonzi Buddy files found in $zsh_config_dir${NC}"
        fi
    fi
done

# =============================================
# 3. REMOVE ALL POSSIBLE COMMAND-NOT-FOUND HANDLERS
# =============================================

echo -e "${BLUE}[3/7] Removing ALL command-not-found handlers...${NC}"

# If command_not_found_handler is defined in current session, unset it
echo -e "${BLUE}Unsetting command_not_found_handler in current session...${NC}"

# Directly attempt to unset the function in the current script
# This is more reliable than using a temporary file in Zsh
if typeset -f command_not_found_handler > /dev/null 2>&1; then
    unfunction command_not_found_handler 2>/dev/null
    echo -e "   ${GREEN}Command not found handler has been unset${NC}"
else
    echo -e "   ${YELLOW}No command not found handler found in current session${NC}"
fi

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

# Cleanup any shell completions - safer Zsh approach
echo -e "   ${YELLOW}Checking Zsh completion paths...${NC}"

# Get completion paths directly in the script to avoid subshell issues
ZSH_COMPLETION_PATHS=($(zsh -c 'for p in $fpath; do echo $p; done' 2>/dev/null || echo "/usr/share/zsh/site-functions"))

for completion_dir in "${ZSH_COMPLETION_PATHS[@]}"; do
    if [[ -d "$completion_dir" ]]; then
        echo -e "   ${BLUE}Checking $completion_dir for completions...${NC}"
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
REMAINING_FILES=$(find ~ -type f -name "*bonzi*" 2>/dev/null || echo "")

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
REMAINING_REFS=$(grep -r "bonzi\|subo\|command_not_found_handler" ~ --include=".*" 2>/dev/null || echo "")

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
