# Bonzi Buddy Terminal Assistant

A friendly terminal assistant that helps with command suggestions and corrections.

![Screenshot from 2025-05-17 03-13-29](https://github.com/user-attachments/assets/1642d450-f816-4f99-af4e-34b1d2c5c7c6)


## Disclaimer

**This project is NOT affiliated with, endorsed by, or related to the original Bonzi Buddy software from the early 2000s.**

This is an open-source terminal utility that helps correct command typos. Unlike the original Bonzi Buddy which was known for containing spyware/adware, this project:
- Is completely open-source so you can verify the code yourself
- Runs locally on your machine without sending any data externally
- Is solely focused on being a helpful terminal assistant

The name is used as a nostalgic reference only.

## Features

- **Intelligent Command Typo Detection**: Uses similarity matching to find the closest valid command, even for heavily mangled typos
- **Command-Not-Found Handler**: Automatically detects and suggests corrections for missing commands
- **Command Explanations**: Provides helpful explanations of what commands actually do
- **Tab Completion Support**: Full tab completion for the `subo` command (sudo with typo checking)
- **Smart Handling of Arguments**: Preserves all command arguments when making corrections
- **Colorful, Friendly Interface**: Easy-to-read color-coded suggestions and explanations
- **Multi-Shell Support**: Seamless integration with both bash and zsh

## Quick Installation
```
 git clone https://github.com/abildma/bonzi-buddy-terminal-assistant.git
 cd bonzi-buddy-terminal-assistant
 chmod +x install.sh && ./install.sh
 source ~/.bashrc or source ~/.zshrc (if using zsh)
```

## Removal
```
 cd bonzi-buddy-terminal-assistant
 chmod +x .uninstall.sh && ./uninstall.sh
 source ~/.bashrc or source ~/.zshrc (if using zsh)
```

## Manual Installation

If you prefer to install manually:

1. Clone this repository
2. Make the scripts executable:
   ```bash
    chmod +x bonzi.sh subo.sh command_not_found.sh bonzi_wrapper.sh zsh_setup.sh
   ```
3. Create aliases for easier access:
   ```bash
   # For bash
    echo "export BONZI_BUDDY_DIR=\"(pwd)\"" >> ~/.bashrc
    echo "alias bonzi='BONZI_BUDDY_DIR/bonzi.sh'" >> ~/.bashrc
    echo "alias subo='BONZI_BUDDY_DIR/subo.sh'" >> ~/.bashrc
   
   # For zsh
    echo "export BONZI_BUDDY_DIR=\"(pwd)\"" >> ~/.zshrc
    echo "source \"BONZI_BUDDY_DIR/zsh_setup.sh\"" >> ~/.zshrc
   ```
4. Reload your shell:
   ```bash
    source ~/.bashrc  # or source ~/.zshrc
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

### Command Explanations
The system includes a database of command explanations that helps you understand what each command does when it's suggested.

### Tab Completion
The `subo` command leverages the existing tab completion system from sudo, allowing you to enjoy both typo checking and full tab completion when using sudo commands.

## Customization

### Adding New Commands
You can easily add more commands to the detection system by editing the `COMMON_COMMANDS` array in `command_not_found.sh`. The system will automatically detect typos for any command you add.

### Extending Command Explanations
To add explanations for more commands or customize existing ones, edit the `get_command_explanation()` function in `command_explanations.sh`.
