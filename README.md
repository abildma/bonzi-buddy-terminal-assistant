# Bonzi Buddy Terminal Assistant

A friendly terminal assistant that helps with command suggestions and corrections.

![Screenshot from 2025-05-17 03-13-29](https://github.com/user-attachments/assets/1642d450-f816-4f99-af4e-34b1d2c5c7c6)


## About

**This project is NOT affiliated with, endorsed by, or related to the original Bonzi Buddy software from the early 2000s.**

This is an open-source terminal utility that helps correct command typos and provides helpful assistance in your terminal. Key characteristics:
- Completely open-source and transparent
- Runs locally on your machine without any external connections
- Designed to make your terminal experience more productive and enjoyable

The name is used as a nostalgic reference to bring a touch of friendly assistance to your command line.

## Features

- **Intelligent Command Typo Detection**: Uses similarity matching to find the closest valid command, even for heavily mangled typos
- **Command-Not-Found Handler**: Automatically detects and suggests corrections for missing commands
- **Command Explanations**: Provides helpful explanations of what commands actually do
- **Tab Completion Support**: Full tab completion for the `subo` command (sudo with typo checking)
- **Smart Handling of Arguments**: Preserves all command arguments when making corrections
- **Colorful, Friendly Interface**: Easy-to-read color-coded suggestions and explanations
- **Zsh Integration**: Seamless integration with Zsh shell

## Quick Installation

> **Note:** Bonzi Buddy currently only supports Zsh. See the [Contributing](#contributing) section if you'd like to help add Bash support!

```bash
# Clone the repository
git clone https://github.com/abildma/bonzi-buddy-terminal-assistant.git
cd bonzi-buddy-terminal-assistant

# Run the installer
chmod +x install.sh && ./install.sh

# Activate Bonzi Buddy in your current session
source ~/.zshrc
```

## Removal

```bash
# Navigate to the repository directory
cd bonzi-buddy-terminal-assistant

# Run the uninstaller
chmod +x uninstall.sh && ./uninstall.sh

# Apply changes to your current session
source ~/.zshrc
```

## Manual Installation

If you prefer to set things up manually:

1. Clone the repository
```bash
git clone https://github.com/abildma/bonzi-buddy-terminal-assistant.git
cd bonzi-buddy-terminal-assistant
```

2. Make the scripts executable
```bash
chmod +x bonzi.sh command_not_found.sh subo.sh zsh_setup.sh
```

3. Add Bonzi Buddy to your Zsh configuration
```bash
# Add to your ~/.zshrc file
export BONZI_BUDDY_DIR="/path/to/bonzi-buddy"
source "$BONZI_BUDDY_DIR/zsh_setup.sh"
```

4. Set up the command-not-found handler
```bash
# For Zsh with Oh-My-Zsh
if [[ -d ~/.oh-my-zsh/functions ]]; then
    cp $BONZI_BUDDY_DIR/command_not_found.sh ~/.oh-my-zsh/functions/command_not_found_handler
    chmod +x ~/.oh-my-zsh/functions/command_not_found_handler
else
    # For standard Zsh without Oh-My-Zsh
    # Create functions directory if it doesn't exist
    mkdir -p ~/.zsh/functions
    cp $BONZI_BUDDY_DIR/command_not_found.sh ~/.zsh/functions/command_not_found_handler
    chmod +x ~/.zsh/functions/command_not_found_handler
    # Add the function path to fpath in your .zshrc
    echo 'fpath=(~/.zsh/functions $fpath)' >> ~/.zshrc
    echo 'autoload -Uz command_not_found_handler' >> ~/.zshrc
fi
```

## Usage

After installation, Bonzi Buddy works in several powerful ways:

### 1. Command-Not-Found Handler (Automatic)

If you type a non-existent command, Bonzi Buddy will automatically detect it and suggest corrections:

```bash
lsbkadsa -a
Bonzi Buddy detected a missing command...
Bonzi Buddy: Did you mean: lsblk?
ℹ️  lsblk - Lists information about block devices (storage)
Would you like to try the suggested command? (Y/n): 
# Press Enter to accept
Bonzi Buddy: Running: lsblk -a
[Command output appears here]
```

### 2. Direct `bonzi` Command

You can also explicitly run any command through Bonzi Buddy:

```bash
bonzi sudo apt opdate
Bonzi Buddy is here to help!
Bonzi Buddy: Did you mean: apt update?
ℹ️  apt - Advanced package tool for Debian/Ubuntu
Would you like to try the suggested command? (Y/n): 
[Command output appears here]
```

### 3. `subo` Command (For sudo operations with tab completion)

Use `subo` for commands that need sudo privileges. It supports full tab completion just like sudo:

```bash
subo apt updaet
Bonzi Buddy: Did you mean: update?
ℹ️  apt - Advanced package tool for Debian/Ubuntu
Would you like to try the suggested command? (Y/n): 
Bonzi Buddy: Running: sudo apt update
[Command output appears here]
```

### 4. Command Explanations

Every suggestion now comes with a brief explanation of what the command does, helping you learn as you use the terminal:

## How It Works

### Smart Command Detection
Bonzi Buddy uses intelligent string similarity detection to find the closest matching command in our library of common Linux commands. This means it can detect even heavily mangled typos like `lsbkadsa` → `lsblk` without having to hardcode every possible misspelling.

### Requirements
- Zsh shell (version 5.0 or higher recommended)
- Oh-My-Zsh (recommended but not required)
- Common Linux utilities (`grep`, `sed`, `awk`, `find`)

### Command Explanations
The system includes a database of command explanations that helps you understand what each command does when it's suggested.

### Tab Completion
The `subo` command leverages the existing tab completion system from sudo, allowing you to enjoy both typo checking and full tab completion when using sudo commands.

## Customization
- Adding New Commands
You can easily add more commands to the detection system by editing the `COMMON_COMMANDS` array in `command_not_found.sh`. The system will automatically detect typos for any command you add.

### Extending Command Explanations
To add explanations for more commands or customize existing ones, edit the `get_command_explanation()` function in `command_explanations.sh`.

## Contributing

Contributions are welcome! Here are some ways you can help improve Bonzi Buddy:

- Add support for more commands in the detection system
- Improve typo detection algorithm
- Add more detailed command explanations
- Create themes or customization options
- Add support for other shells (fish, bash, etc.)

To contribute:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
