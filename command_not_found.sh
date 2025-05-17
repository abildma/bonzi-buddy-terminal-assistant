#!/bin/zsh

# Bonzi Buddy Command Not Found Handler for Zsh
# This script is called automatically when a command isn't found in Zsh

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the command explanations
source "$SCRIPT_DIR/command_explanations.sh"

# Display the initial message - keep this one with Bonzi Buddy name for branding
echo -e "${PURPLE}Bonzi Buddy${NC} detected a ${YELLOW}missing command${NC}..."

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
    echo -e "    ${YELLOW}┌───────────────────────────┐${NC}"
    echo -e "    ${YELLOW}│${NC}  Did you mean: ${GREEN}cd ..${NC}        ${YELLOW}│${NC}"
    echo -e "    ${YELLOW}└───────────────────────────┘${NC}"
    echo -e "${CYAN}ℹ️  cd${NC} - $explanation"
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
    echo -e "    ${YELLOW}┌───────────────────────────┐${NC}"
    echo -e "    ${YELLOW}│${NC}  Did you mean: ${GREEN}ls${NC}          ${YELLOW}│${NC}"
    echo -e "    ${YELLOW}└───────────────────────────┘${NC}"
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
    local cmd_length=${#corrected}
    local padding=$((20 - cmd_length))
    local spaces=""
    for ((i=0; i<padding; i++)); do
      spaces="$spaces "
    done
    
    echo -e "    ${YELLOW}┌───────────────────────────┐${NC}"
    echo -e "    ${YELLOW}│${NC}  Did you mean: ${GREEN}$corrected${NC}$spaces${YELLOW}│${NC}"
    echo -e "    ${YELLOW}└───────────────────────────┘${NC}"
    echo -e "${CYAN}ℹ️  ls${NC} - $explanation"
    echo -n "Would you like to try the suggested command? (Y/n): "
    read CONFIRM
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
      echo -e "${BLUE}Command not executed.${NC}"
      return 127 # Standard code for command not found
    else
      echo -e "${BLUE}Running:${NC} ${GREEN}$corrected $CMD_ARGS${NC}"
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
      local cmd_length=${#closest_cmd}
      local padding=$((20 - cmd_length))
      local spaces=""
      for ((i=0; i<padding; i++)); do
        spaces="$spaces "
      done
      
      echo -e "    ${YELLOW}┌───────────────────────────┐${NC}"
      echo -e "    ${YELLOW}│${NC}  Did you mean: ${GREEN}$closest_cmd${NC}$spaces${YELLOW}│${NC}"
      echo -e "    ${YELLOW}└───────────────────────────┘${NC}"
      echo -e "${CYAN}ℹ️  $closest_cmd${NC} - $explanation"
      echo -n "Would you like to try the suggested command? (Y/n): "
      read CONFIRM
      
      if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
        echo -e "${BLUE}Command not executed.${NC}"
        return 127 # Standard code for command not found
      else
        echo -e "${BLUE}Running:${NC} ${GREEN}$closest_cmd $CMD_ARGS${NC}"
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
