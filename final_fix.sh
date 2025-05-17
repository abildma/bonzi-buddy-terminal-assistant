#!/bin/bash
# Final fix for remaining Bonzi Buddy issues
# Fixes: command explanations export error and command-not-found handler

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${MAGENTA}Bonzi Buddy Final Fix Tool${NC}"
echo "This script will fix the remaining issues with your installation."
echo ""

# 1. Check that ~/.bonzi-buddy exists
if [ ! -d "$HOME/.bonzi-buddy" ]; then
    echo -e "${RED}Error: ~/.bonzi-buddy directory not found!${NC}"
    echo "Please run ./install_hidden.sh first."
    exit 1
fi

# Set the Bonzi Buddy directory
BONZI_DIR="$HOME/.bonzi-buddy"

# 2. Fix command_explanations.sh - Remove the export -f line
echo -e "${BLUE}Fixing command explanations...${NC}"
cat > "$BONZI_DIR/command_explanations.sh" << 'EOF'
#!/bin/bash
# Command explanations for Bonzi Buddy

# Function to get explanation for a command
get_command_explanation() {
    local cmd="$1"
    case "$cmd" in
        ls) echo "List directory contents" ;;
        cd) echo "Change directory" ;;
        cp) echo "Copy files and directories" ;;
        mv) echo "Move/rename files and directories" ;;
        rm) echo "Remove files or directories" ;;
        mkdir) echo "Create directories" ;;
        chmod) echo "Change file permissions" ;;
        chown) echo "Change file owner and group" ;;
        grep) echo "Search text using patterns" ;;
        find) echo "Search for files in a directory hierarchy" ;;
        ps) echo "Report process status" ;;
        kill) echo "Terminate processes" ;;
        sudo) echo "Execute a command as another user (typically root)" ;;
        apt) echo "Advanced package tool for Debian/Ubuntu" ;;
        "apt update") echo "Update list of available packages" ;;
        "apt upgrade") echo "Upgrade the installed packages" ;;
        "apt install") echo "Install new packages" ;;
        "apt remove") echo "Remove packages" ;;
        "apt autoremove") echo "Remove automatically all unused packages" ;;
        "apt search") echo "Search for packages" ;;
        "apt list") echo "List packages with criteria" ;;
        "apt show") echo "Show package details" ;;
        cat) echo "Concatenate and display files" ;;
        less) echo "View file contents with pagination" ;;
        man) echo "Display system manual pages" ;;
        ln) echo "Create links between files" ;;
        df) echo "Report file system disk space usage" ;;
        du) echo "Estimate file space usage" ;;
        free) echo "Display amount of free and used memory" ;;
        top) echo "Display Linux processes" ;;
        uname) echo "Print system information" ;;
        whoami) echo "Print effective user ID" ;;
        tar) echo "Manipulate tape archives" ;;
        zip) echo "Package and compress files" ;;
        unzip) echo "Extract compressed files" ;;
        ssh) echo "OpenSSH remote login client" ;;
        scp) echo "Secure copy (remote file copy program)" ;;
        ping) echo "Send ICMP ECHO_REQUEST to network hosts" ;;
        ifconfig) echo "Configure network interface parameters" ;;
        ip) echo "Show/manipulate routing, devices, policy routing and tunnels" ;;
        systemctl) echo "Control the systemd system and service manager" ;;
        journalctl) echo "Query the systemd journal" ;;
        docker) echo "Docker container management" ;;
        git) echo "The fast distributed version control system" ;;
        curl) echo "Transfer data from or to a server" ;;
        wget) echo "Non-interactive network downloader" ;;
        *) echo "" ;;
    esac
}

# NO EXPORT - it's causing problems on some systems
EOF
chmod +x "$BONZI_DIR/command_explanations.sh"

# 3. Update command_not_found.sh to directly include command explanations
echo -e "${BLUE}Updating command not found handler...${NC}"
cat > "$BONZI_DIR/command_not_found.sh" << 'EOF'
#!/bin/zsh
# Bonzi Buddy Command Not Found Handler

# Colors for terminal output
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RED='\033[0;31m' 
NC='\033[0m' # No Color

# Get command explanations directly (to avoid export issues)
get_command_explanation() {
    local cmd="$1"
    case "$cmd" in
        ls) echo "List directory contents" ;;
        cd) echo "Change directory" ;;
        cp) echo "Copy files and directories" ;;
        mv) echo "Move/rename files and directories" ;;
        rm) echo "Remove files or directories" ;;
        mkdir) echo "Create directories" ;;
        chmod) echo "Change file permissions" ;;
        sudo) echo "Execute a command as another user (typically root)" ;;
        apt) echo "Advanced package tool for Debian/Ubuntu" ;;
        "apt update") echo "Update list of available packages" ;;
        "apt upgrade") echo "Upgrade the installed packages" ;;
        "apt install") echo "Install new packages" ;;
        git) echo "The fast distributed version control system" ;;
        *) echo "" ;;
    esac
}

# Function to suggest apt package for missing command
suggest_package() {
    local cmd="$1"
    local package=""
    
    # Try to find a package that provides the command
    if command -v apt-cache &> /dev/null; then
        package=$(apt-cache search --names-only "^$cmd$" 2>/dev/null | cut -d " " -f1 | head -n1)
        
        if [ -z "$package" ]; then
            package=$(apt-cache search --names-only "$cmd" 2>/dev/null | cut -d " " -f1 | head -n1)
        fi
    fi
    
    echo "$package"
}

# Function to suggest a correction for a command
suggest_correction() {
    local cmd="$1"
    local possible_cmd=""
    
    # Check for common typos
    case "$cmd" in
        # Basic commands with common typos
        "sl") possible_cmd="ls" ;;
        "mr") possible_cmd="rm" ;;
        "msdir") possible_cmd="mkdir" ;;
        "gt") possible_cmd="git" ;;
        "cd..") possible_cmd="cd .." ;;
        "cta") possible_cmd="cat" ;;
        "bim"|"vim") possible_cmd="vim" ;;
        "sudp") possible_cmd="sudo" ;;
        "suod") possible_cmd="sudo" ;;
        "ll") possible_cmd="ls -l" ;;
        "la") possible_cmd="ls -a" ;;
        "lsa") possible_cmd="ls -a" ;;
        "lsal"|"lsla") possible_cmd="ls -la" ;;
        "lsl") possible_cmd="ls -l" ;;
        "gerp") possible_cmd="grep" ;;
        "gti") possible_cmd="git" ;;
        "lesss") possible_cmd="less" ;;
        
        # APT related
        "apt-get"|"apt-gt") possible_cmd="apt" ;;
        "apt-et") possible_cmd="apt-get" ;;
        "atp"|"pa") possible_cmd="apt" ;;
        "agt") possible_cmd="apt" ;;
        "apt search"|"apt-search"|"aptsearch") possible_cmd="apt search" ;;
        "apt install"|"apt-install"|"aptinstall") possible_cmd="apt install" ;;
        "apt remove"|"apt-remove"|"aptremove") possible_cmd="apt remove" ;;
        "apt opdate"|"apt-update"|"aptupdate") possible_cmd="apt update" ;;
        "apt updte"|"apt upate"|"apt updae") possible_cmd="apt update" ;;
        "apt opgrade"|"apt-upgrade"|"aptupgrade") possible_cmd="apt upgrade" ;;
        "apt upgrde"|"apt upgade"|"apt upgrad") possible_cmd="apt upgrade" ;;
        "apt upgrae") possible_cmd="apt upgrade" ;;
        "apt-gt install"|"apt-get isntall") possible_cmd="apt install" ;;
        
        # No common correction found
        *) 
            # Check for close matches with edit distance of 1-2
            local most_similar=""
            local min_distance=3
            local distance=0
            
            # List of common commands to check against
            local common_commands=("ls" "cd" "cp" "mv" "rm" "mkdir" "chmod" "grep" "find" "ps" "kill" "sudo" "apt" "cat" "less" "man" "ln" "df" "du" "free" "top" "git")
            
            for c in "${common_commands[@]}"; do
                # Very simple distance calculation
                if [ "${#cmd}" -eq "${#c}" ]; then
                    distance=0
                    for ((i=0; i<${#cmd}; i++)); do
                        if [ "${cmd:$i:1}" != "${c:$i:1}" ]; then
                            ((distance++))
                        fi
                    done
                    
                    # Check if this is a better match
                    if [ "$distance" -lt "$min_distance" ]; then
                        min_distance=$distance
                        most_similar=$c
                    fi
                fi
            done
            
            # If we found a reasonably close match
            if [ "$min_distance" -lt 3 ] && [ -n "$most_similar" ]; then
                possible_cmd="$most_similar"
            fi
            ;;
    esac
    
    echo "$possible_cmd"
}

# Main handler function
main() {
    local cmd="$1"
    shift
    local args="$@"
    local correction=$(suggest_correction "$cmd")
    local package=$(suggest_package "$cmd")
    
    echo -e "${PURPLE}Bonzi Buddy detected a missing command...${NC}"
    
    if [ -n "$correction" ]; then
        echo -e "    ${YELLOW}[ Did you mean: ${GREEN}$correction${YELLOW}? ]${NC}"
        
        # Show command explanation if available
        local explanation=$(get_command_explanation "$correction")
        if [ -n "$explanation" ]; then
            echo -e "ℹ️   ${CYAN}$correction - $explanation${NC}"
        fi
        
        read -p "Would you like to try the suggested command? (Y/n): " choice
        case "$choice" in
            n|N) 
                echo "Command not executed."
                return 127
                ;;
            *) 
                echo -e "Running: ${GREEN}$correction $args${NC}"
                eval "$correction $args"
                return $?
                ;;
        esac
    elif [ -n "$package" ]; then
        echo "The program '$cmd' is not currently installed."
        echo -e "${YELLOW}You can install it by typing:${NC}"
        echo -e "    ${GREEN}sudo apt install $package${NC}"
        read -p "Would you like to install it now? (y/N): " choice
        case "$choice" in
            y|Y) 
                echo -e "Running: ${GREEN}sudo apt install $package${NC}"
                sudo apt install "$package"
                return $?
                ;;
            *) 
                echo "Installation canceled."
                return 127
                ;;
        esac
    else
        echo -e "${RED}Command '$cmd' not found and no correction available.${NC}"
        echo -e "${BLUE}Use subo to automatically use sudo and bonzi${NC}"
        echo -e "${YELLOW}Usage: bonzi.sh [command]${NC}"
        echo -e "${YELLOW}Example: bonzi.sh sudo apt opdate${NC}"
        return 127
    fi
}

# Execute the main function with all arguments
main "$@"
EOF
chmod +x "$BONZI_DIR/command_not_found.sh"

# 4. Fix the .zshrc integration
echo -e "${BLUE}Fixing .zshrc integration...${NC}"
# First backup the current .zshrc
cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"

# Clean out the existing Bonzi Buddy parts
TMP_FILE="$(mktemp)"
grep -v "# Bonzi Buddy" "$HOME/.zshrc" | 
grep -v "BONZI_BUDDY_DIR" |
grep -v "command_not_found_handler" |
grep -v "compdef _subo" |
grep -v "_subo_complete" > "$TMP_FILE"
mv "$TMP_FILE" "$HOME/.zshrc"

# Add a fresh configuration to .zshrc
cat << EOF >> "$HOME/.zshrc"

# Bonzi Buddy - Terminal Assistant (New Configuration)
export BONZI_BUDDY_DIR="$BONZI_DIR"

# Add ~/bin to PATH if not already there
if [[ ":\$PATH:" != *":\$HOME/bin:"* ]]; then
    export PATH="\$HOME/bin:\$PATH"
fi

# Command Not Found Handler
command_not_found_handler() {
    "\$BONZI_BUDDY_DIR/command_not_found.sh" "\$@"
    return \$?
}

# Enable tab completion (simplified)
fpath=("\$BONZI_BUDDY_DIR" \$fpath)
autoload -Uz compinit
compinit
EOF

# 5. Create a simple completion system
echo -e "${BLUE}Setting up simplified completion...${NC}"
cat > "$BONZI_DIR/_subo" << 'EOF'
#compdef subo
# Basic completion for subo command

# Provide completion for apt subcommands
_subo_apt_commands=(
  'update:Refresh list of available packages'
  'upgrade:Upgrade packages to newer versions'
  'install:Install new packages'
  'remove:Remove packages'
  'purge:Remove packages and configuration files'
  'autoremove:Remove automatically installed dependencies'
  'clean:Clean local package cache'
  'autoclean:Clean old versions from package cache'
)

# Provide completion for first-level commands
_subo_commands=(
  'apt:Advanced package tool for Debian/Ubuntu'
  'apt-get:Legacy package management tool'
  'systemctl:Control systemd services'
  'service:Control system services'
  'docker:Manage Docker containers'
)

# Main completion function
_subo() {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments -C \
    '1: :->command' \
    '2: :->subcommand' \
    '*: :->args' \
    
  case $state in
    command)
      _describe -t commands "subo commands" _subo_commands
      ;;
    subcommand)
      case $words[2] in
        apt)
          _describe -t subcommands "apt commands" _subo_apt_commands
          ;;
        *)
          _files
          ;;
      esac
      ;;
    *)
      _files
      ;;
  esac
}

_subo "$@"
EOF
chmod +x "$BONZI_DIR/_subo"

# 6. Export variables for current session
export BONZI_BUDDY_DIR="$BONZI_DIR"
export PATH="$HOME/bin:$PATH"

echo -e "${GREEN}Final fixes complete!${NC}"
echo -e "${YELLOW}For these changes to take effect, please restart your shell:${NC}"
echo -e "${MAGENTA}exec zsh${NC}"
echo ""
echo -e "${BLUE}After restarting, try the following:${NC}"
echo -e "1. Type ${GREEN}lsla${BLUE} (should suggest ls -la)"
echo -e "2. Press Tab after typing ${GREEN}subo apt ${BLUE}(should show completions)"
echo -e "3. Try ${GREEN}subo apt opdate${BLUE} (should suggest 'apt update')"
