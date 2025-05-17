#!/bin/zsh

# Bonzi Buddy Command Not Found Handler for Zsh
# This script is called automatically when a command isn't found in Zsh

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

# Get the directory of this script - fix for Zsh compatibility
if [ -n "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
else
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
            "pwd") echo "Print working directory" ;;
            "mkdir") echo "Make directories" ;;
            "rm") echo "Remove files or directories" ;;
            "cp") echo "Copy files and directories" ;;
            "mv") echo "Move (rename) files" ;;
            "cat") echo "Concatenate files and print to standard output" ;;
            "grep") echo "Search for patterns in text" ;;
            "find") echo "Search for files" ;;
            "ps") echo "Report process status" ;;
            "kill") echo "Send a signal to a process" ;;
            "df") echo "Report file system disk space usage" ;;
            "du") echo "Estimate file space usage" ;;
            "tar") echo "Archive utility" ;;
            "zip") echo "Package and compress files" ;;
            "unzip") echo "Extract compressed files" ;;
            "ssh") echo "OpenSSH remote login client" ;;
            "scp") echo "Secure copy files between hosts" ;;
            "sudo") echo "Execute command as another user" ;;
            "apt") echo "Advanced package tool for Debian/Ubuntu" ;;
            "dnf") echo "Package manager for RPM-based distributions" ;;
            "yum") echo "Package manager for older RPM-based distributions" ;;
            "pacman") echo "Package manager for Arch Linux" ;;
            "git") echo "Distributed version control system" ;;
            "make") echo "Build automation tool" ;;
            "gcc") echo "GNU Compiler Collection" ;;
            "python") echo "Python programming language interpreter" ;;
            "python3") echo "Python 3 programming language interpreter" ;;
            "top") echo "Display system processes" ;;
            "htop") echo "Interactive process viewer" ;;
            "ifconfig") echo "Configure network interface" ;;
            "ip") echo "Show / manipulate routing, devices, policy routing and tunnels" ;;
            "ping") echo "Send ICMP ECHO_REQUEST to network hosts" ;;
            "netstat") echo "Print network connections, routing tables, etc." ;;
            "systemctl") echo "Control the systemd system and service manager" ;;
            "journalctl") echo "Query the systemd journal" ;;
            "lsblk") echo "Lists information about block devices (storage)" ;;
            "lsusb") echo "List USB devices" ;;
            "lspci") echo "List PCI devices" ;;
            *) echo "Common Linux command" ;;
        esac
    }
fi

# Display the initial message with enhanced branding
echo -e "${BRIGHT_PURPLE}Bonzi Buddy${NC} ${GRAY}detected a${NC} ${YELLOW}missing command${NC}${GRAY}...${NC}"
# No blank line - keep output compact
# Get the full command string and the command name
CMD_STRING="$@"
CMD_NAME="$1"
CMD_ARGS="${@:2}"

# Extract just the command name without any options or arguments
BASE_CMD=$(echo "$CMD_NAME" | awk '{print $1}')

# List of common Linux commands to check against
COMMON_COMMANDS=(
  # File operations
  "ls" "cd" "pwd" "mkdir" "rm" "cp" "mv" "touch" "cat" "less" "more" "head" "tail"
  # System info
  "lsblk" "df" "du" "free" "top" "htop" "uname" "lscpu" "lsusb" "lspci"
  # Text processing
  "grep" "awk" "sed" "find" "xargs" "sort" "uniq" "wc" "diff" "tr"
  # Network
  "ping" "netstat" "ifconfig" "ip" "nmap" "traceroute" "ssh" "dig" "nslookup"
  # System management
  "systemctl" "journalctl" "chown" "chmod" "mount" "umount"
  # Package management
  "apt" "apt-get" "dpkg" "yum" "dnf" "pacman" "snap"
  # Compression
  "tar" "gzip" "gunzip" "zip" "unzip" "bzip2"
  # Dev tools
  "git" "make" "gcc" "python" "python3" "java" "javac" "npm" "node"
  # Other common commands
  "sudo" "su" "passwd" "useradd" "usermod" "userdel" "groupadd"
)

# Handle special cases first
case "$BASE_CMD" in
  "cd..")
    explanation=$(get_command_explanation "cd")
    echo -e ""
    # Calculate proper spacing for cd ..
    local cmd="cd .."
    local cmd_length=${#cmd}
    local padding=$((13 - cmd_length))
    # Ensure padding is at least 1 space
    if [ $padding -lt 1 ]; then
        padding=1
    fi
    local spaces=""
    for ((i=0; i<padding; i++)); do
      spaces="$spaces "
    done
    
    # Simple bracketed style that works reliably across all terminals
    echo -e "    ${YELLOW}[${NC} ${WHITE}Did you mean:${NC} ${BRIGHT_GREEN}cd ..${NC}${GRAY}?${NC} ${YELLOW}]${NC}"
    echo -e "${CYAN}ℹ️  ${BOLD}cd${NC} ${GRAY}-${NC} ${LIGHT_BLUE}$explanation${NC}"
    echo -n "Would you like to try the suggested command? (Y/n): "
    read CONFIRM
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
      echo -e "${BLUE}Command not executed.${NC}"
      return 127 # Standard code for command not found
    else
      echo -e "${BLUE}Running:${NC} ${GREEN}cd ..${NC}"
      cd ..
    fi
    exit $?
    ;;
    
  "sl")
    explanation=$(get_command_explanation "ls")
    echo -e ""
    # Calculate proper spacing for ls
    local cmd="ls"
    local cmd_length=${#cmd}
    local padding=$((13 - cmd_length))
    # Ensure padding is at least 1 space
    if [ $padding -lt 1 ]; then
        padding=1
    fi
    local spaces=""
    for ((i=0; i<padding; i++)); do
      spaces="$spaces "
    done
    
    # Simple bracketed style that works reliably across all terminals
    echo -e "    ${YELLOW}[${NC} ${WHITE}Did you mean:${NC} ${BRIGHT_GREEN}ls${NC}${GRAY}?${NC} ${YELLOW}]${NC}"
    echo -e "${CYAN}ℹ️  ls${NC} - $explanation"
    echo -n "Would you like to try the suggested command? (Y/n): "
    read CONFIRM
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
      echo -e "${BLUE}Command not executed.${NC}"
      return 127 # Standard code for command not found
    else
      echo -e "${BLUE}Running:${NC} ${GREEN}ls $CMD_ARGS${NC}"
      ls $CMD_ARGS
    fi
    exit $?
    ;;
    
  "ls-"*)
    # Handle ls-la, ls-l, etc.
    corrected="ls ${BASE_CMD#ls-}"
    explanation=$(get_command_explanation "ls")
    echo -e ""
    # Calculate proper spacing for box formatting
    local cmd_length=${#corrected}
    local padding=$((13 - cmd_length))
    # Ensure padding is at least 1 space
    if [ $padding -lt 1 ]; then
        padding=1
    fi
    local spaces=""
    for ((i=0; i<padding; i++)); do
      spaces="$spaces "
    done
    
    # Simple bracketed style that works reliably across all terminals
    echo -e "    ${YELLOW}[${NC} ${WHITE}Did you mean:${NC} ${BRIGHT_GREEN}$corrected${NC}${GRAY}?${NC} ${YELLOW}]${NC}"
    echo -e "${CYAN}ℹ️  ls${NC} - $explanation"
    echo -n "Would you like to try the suggested command? (Y/n): "
    read CONFIRM
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
      echo -e "${BLUE}Command not executed.${NC}"
      return 127 # Standard code for command not found
    else
      echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}$corrected${NC}"
      eval "$corrected $CMD_ARGS"
    fi
    exit $?
    ;;
    
  *)
    # Find the closest matching command using edit distance
    closest_cmd=""
    min_distance=100  # A large number
    
    for cmd in "${COMMON_COMMANDS[@]}"; do
      # Skip very short commands to avoid false positives
      if [[ ${#cmd} -lt 2 ]]; then
        continue
      fi
      
      # Simple edit distance approximation
      # If the first character matches and length is similar
      if [[ "${BASE_CMD:0:1}" == "${cmd:0:1}" ]]; then
        len_diff=$(( ${#BASE_CMD} - ${#cmd} ))
        len_diff=${len_diff#-}  # absolute value
        
        if [[ $len_diff -lt 3 ]]; then
          # Check if there's substantial overlap
          match=0
          for (( i=0; i<${#cmd} && i<${#BASE_CMD}; i++ )); do
            if [[ "${BASE_CMD:$i:1}" == "${cmd:$i:1}" ]]; then
              ((match++))
            fi
          done
          
          # Calculate a simple similarity score
          min_len=$(( ${#cmd} < ${#BASE_CMD} ? ${#cmd} : ${#BASE_CMD} ))
          similarity=$(( match * 10 / min_len ))
          distance=$(( 10 - similarity ))
          
          if [[ $distance -lt $min_distance ]]; then
            min_distance=$distance
            closest_cmd=$cmd
          fi
        fi
      fi
    done
    
    # If we found a close match
    if [[ -n "$closest_cmd" && $min_distance -lt 7 ]]; then
      # Get an explanation of what the command does
      explanation=$(get_command_explanation "$closest_cmd")
      
      echo -e ""
      # Calculate proper spacing for box formatting
      local cmd_length=${#closest_cmd}
      local padding=$((13 - cmd_length))
      # Ensure padding is at least 1 space
      if [ $padding -lt 1 ]; then
          padding=1
      fi
      local spaces=""
      for ((i=0; i<padding; i++)); do
        spaces="$spaces "
      done
      
      # Simple bracketed style that works reliably across all terminals
      echo -e "    ${YELLOW}[${NC} ${WHITE}Did you mean:${NC} ${BRIGHT_GREEN}$closest_cmd${NC}${GRAY}?${NC} ${YELLOW}]${NC}"
      echo -e "${CYAN}ℹ️  ${BOLD}$closest_cmd${NC} ${GRAY}-${NC} ${LIGHT_BLUE}$explanation${NC}"
      echo -n "Would you like to try the suggested command? (Y/n): "
      read CONFIRM
      
      if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
        echo -e "${RED}Command not executed.${NC}"
        return 127 # Standard code for command not found
      else
        echo -e "${BLUE}Running:${NC} ${BRIGHT_GREEN}$closest_cmd $CMD_ARGS${NC}"
        eval "$closest_cmd $CMD_ARGS"
      fi
      exit $?
    else
      # No good match found, check with bonzi.sh as a fallback
      "$SCRIPT_DIR/bonzi.sh" "$CMD_STRING"
      exit $?
    fi
    ;;
esac
