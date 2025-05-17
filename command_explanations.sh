#!/bin/bash

# Command Explanations for Bonzi Buddy
# Contains brief explanations of common Linux commands

# Function to get a brief explanation of a command
get_command_explanation() {
    local cmd="$1"
    
    case "$cmd" in
        # File operations
        "ls")
            echo "Lists directory contents"
            ;;
        "cd")
            echo "Changes the current directory"
            ;;
        "pwd")
            echo "Prints the current working directory"
            ;;
        "mkdir")
            echo "Creates a new directory"
            ;;
        "rm")
            echo "Removes files or directories"
            ;;
        "cp")
            echo "Copies files and directories"
            ;;
        "mv")
            echo "Moves or renames files and directories"
            ;;
        "touch")
            echo "Creates an empty file or updates file timestamps"
            ;;
        "cat")
            echo "Concatenates and displays file contents"
            ;;
        "less")
            echo "Views file contents with pagination"
            ;;
        "more")
            echo "Views file contents one screen at a time"
            ;;
        "head")
            echo "Displays the first lines of a file"
            ;;
        "tail")
            echo "Displays the last lines of a file"
            ;;
            
        # System info
        "lsblk")
            echo "Lists information about block devices (storage)"
            ;;
        "df")
            echo "Reports file system disk space usage"
            ;;
        "du")
            echo "Estimates file space usage"
            ;;
        "free")
            echo "Displays amount of free and used memory"
            ;;
        "top")
            echo "Displays and updates sorted information about processes"
            ;;
        "htop")
            echo "Interactive process viewer, an enhanced version of top"
            ;;
        "uname")
            echo "Prints system information"
            ;;
        "lscpu")
            echo "Displays information about CPU architecture"
            ;;
        "lsusb")
            echo "Lists USB devices"
            ;;
        "lspci")
            echo "Lists PCI devices"
            ;;
            
        # Text processing
        "grep")
            echo "Searches for patterns in files"
            ;;
        "awk")
            echo "Pattern scanning and text processing language"
            ;;
        "sed")
            echo "Stream editor for filtering and transforming text"
            ;;
        "find")
            echo "Searches for files in a directory hierarchy"
            ;;
        "xargs")
            echo "Builds and executes commands from standard input"
            ;;
        "sort")
            echo "Sorts lines of text files"
            ;;
        "uniq")
            echo "Reports or filters out repeated lines"
            ;;
        "wc")
            echo "Prints newline, word, and byte counts for files"
            ;;
        "diff")
            echo "Compares files line by line"
            ;;
        "tr")
            echo "Translates or deletes characters"
            ;;
            
        # Network
        "ping")
            echo "Sends ICMP ECHO_REQUEST to network hosts"
            ;;
        "netstat")
            echo "Displays network connections, routing tables, etc."
            ;;
        "ifconfig")
            echo "Configures network interfaces"
            ;;
        "ip")
            echo "Shows/manipulates routing, devices, policy routing and tunnels"
            ;;
        "nmap")
            echo "Network exploration tool and security/port scanner"
            ;;
        "traceroute")
            echo "Traces the route packets take to a network host"
            ;;
        "ssh")
            echo "Secure shell remote login protocol"
            ;;
        "dig")
            echo "DNS lookup utility"
            ;;
        "nslookup")
            echo "Queries DNS servers for domain name or IP information"
            ;;
            
        # System management
        "systemctl")
            echo "Controls the systemd system and service manager"
            ;;
        "journalctl")
            echo "Queries the systemd journal"
            ;;
        "chown")
            echo "Changes file owner and group"
            ;;
        "chmod")
            echo "Changes file permissions"
            ;;
        "mount")
            echo "Mounts a filesystem"
            ;;
        "umount")
            echo "Unmounts a filesystem"
            ;;
            
        # Package management
        "apt")
            echo "Advanced package tool for Debian/Ubuntu"
            ;;
        "apt-get")
            echo "APT package handling utility"
            ;;
        "dpkg")
            echo "Debian package manager"
            ;;
        "yum")
            echo "Package manager for RPM-based distros"
            ;;
        "dnf")
            echo "Next generation version of YUM package manager"
            ;;
        "pacman")
            echo "Package manager for Arch Linux"
            ;;
        "snap")
            echo "Installs and manages snap packages"
            ;;
            
        # Compression
        "tar")
            echo "Archives files (tape archive)"
            ;;
        "gzip")
            echo "Compresses files using Lempel-Ziv coding"
            ;;
        "gunzip")
            echo "Expands gzip-compressed files"
            ;;
        "zip")
            echo "Packages and compresses files"
            ;;
        "unzip")
            echo "Extracts files from ZIP archives"
            ;;
        "bzip2")
            echo "Compresses files using Burrows-Wheeler algorithm"
            ;;
            
        # Dev tools
        "git")
            echo "Distributed version control system"
            ;;
        "make")
            echo "Maintains program dependencies"
            ;;
        "gcc")
            echo "GNU C/C++ compiler"
            ;;
        "python")
            echo "Python programming language interpreter"
            ;;
        "python3")
            echo "Python 3 programming language interpreter"
            ;;
        "java")
            echo "Java runtime environment"
            ;;
        "javac")
            echo "Java compiler"
            ;;
        "npm")
            echo "Node.js package manager"
            ;;
        "node")
            echo "Node.js JavaScript runtime"
            ;;
            
        # Other common commands
        "sudo")
            echo "Executes a command as another user (typically root)"
            ;;
        "su")
            echo "Switches user"
            ;;
        "passwd")
            echo "Changes user password"
            ;;
        "useradd")
            echo "Creates a new user"
            ;;
        "usermod")
            echo "Modifies a user account"
            ;;
        "userdel")
            echo "Deletes a user account"
            ;;
        "groupadd")
            echo "Creates a new group"
            ;;
        *)
            echo "No explanation available"
            ;;
    esac
}

# Export the function so it can be used by other scripts
export -f get_command_explanation
