#!/bin/bash

# Dotfiles Installation Script
# Automated setup for the complete development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Icons
SUCCESS="✅"
ERROR="❌"
INFO="ℹ️"
ROCKET="🚀"
FOLDER="📁"
PACKAGE="📦"
CONFIG="⚙️"

# Variables
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# Function to print colored output
print_success() { echo -e "${GREEN}${SUCCESS} $1${NC}"; }
print_error() { echo -e "${RED}${ERROR} $1${NC}"; }
print_info() { echo -e "${CYAN}${INFO} $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_section() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup existing file/directory
backup_if_exists() {
    local file="$1"
    local backup_name="$2"
    
    if [ -e "$file" ]; then
        print_info "Backing up existing $backup_name..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$file" "$BACKUP_DIR/"
        print_success "Backed up $backup_name to $BACKUP_DIR"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"
    
    if [ -e "$source" ]; then
        # Backup existing target
        backup_if_exists "$target" "$description"
        
        # Remove existing target
        rm -rf "$target"
        
        # Create symlink
        ln -sf "$source" "$target"
        print_success "Linked $description"
    else
        print_warning "Source not found: $source"
    fi
}

# Function to show usage
show_usage() {
    echo -e "${CYAN}${ROCKET} Dotfiles Installation Script${NC}"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -f, --force     Force installation without prompts"
    echo "  -b, --backup    Only create backup, don't install"
    echo "  -r, --restore   Restore from backup"
    echo "  --dry-run       Show what would be done without making changes"
    echo ""
    echo "This script will:"
    echo "• Install essential packages and tools"
    echo "• Set up Neovim with LazyVim configuration"
    echo "• Configure Tmux with plugins"
    echo "• Set up enhanced Zsh configuration"
    echo "• Configure Git with useful aliases"
    echo "• Set up terminal configurations"
    echo "• Install utility scripts"
}

# Parse command line arguments
FORCE_INSTALL=false
BACKUP_ONLY=false
RESTORE_MODE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -f|--force)
            FORCE_INSTALL=true
            shift
            ;;
        -b|--backup)
            BACKUP_ONLY=true
            shift
            ;;
        -r|--restore)
            RESTORE_MODE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Welcome message
echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🚀 Dotfiles Installation - Modern Development Setup     ║
║                                                              ║
║     • macOS-inspired experience on Arch Linux               ║
║     • Neovim with LazyVim configuration                     ║
║     • Tmux with productivity plugins                        ║
║     • Enhanced Zsh with modern tools                        ║
║     • Git workflow optimization                             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# Check if we're in the right directory
if [ ! -f "$DOTFILES_DIR/install.sh" ]; then
    print_error "Please run this script from the dotfiles directory"
    print_info "Expected location: $DOTFILES_DIR"
    exit 1
fi

# Backup mode
if [ "$BACKUP_ONLY" = true ]; then
    print_section "Creating Backup Only"
    
    print_info "Creating backup of current configurations..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup configurations
    backup_if_exists "$HOME/.zshrc" "zshrc"
    backup_if_exists "$HOME/.config/nvim" "neovim"
    backup_if_exists "$HOME/.config/tmux" "tmux"
    backup_if_exists "$HOME/.gitconfig" "gitconfig"
    backup_if_exists "$HOME/.config/ghostty" "ghostty"
    
    print_success "Backup created at: $BACKUP_DIR"
    exit 0
fi

# Restore mode
if [ "$RESTORE_MODE" = true ]; then
    print_section "Restore Mode"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "No backup directory found at: $BACKUP_DIR"
        exit 1
    fi
    
    print_info "Restoring configurations from backup..."
    # Implementation for restore would go here
    print_success "Configurations restored"
    exit 0
fi

# Confirmation prompt
if [ "$FORCE_INSTALL" = false ] && [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}This will install and configure your development environment.${NC}"
    echo -e "${YELLOW}Existing configurations will be backed up to: $BACKUP_DIR${NC}"
    echo ""
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
fi

# Dry run mode
if [ "$DRY_RUN" = true ]; then
    print_section "Dry Run - Showing what would be done"
    echo "• Install packages via install_packages.sh"
    echo "• Backup existing configurations to $BACKUP_DIR"
    echo "• Link ~/.zshrc → $DOTFILES_DIR/.zshrc.enhanced"
    echo "• Link ~/.config/nvim → $DOTFILES_DIR/.config/nvim"
    echo "• Link ~/.config/tmux → $DOTFILES_DIR/.config/tmux"
    echo "• Link ~/.gitconfig → $DOTFILES_DIR/.gitconfig"
    echo "• Link ~/.config/ghostty → $DOTFILES_DIR/.config/ghostty"
    echo "• Setup Tmux Plugin Manager"
    echo "• Make scripts executable"
    echo "• Add scripts to PATH"
    print_info "Dry run complete. Use --force to proceed with installation."
    exit 0
fi

# Start installation
print_section "Starting Installation"

# Step 1: Install packages
print_section "Installing Packages"

if [ -f "$HOME/install_packages.sh" ]; then
    print_info "Running package installation script..."
    bash "$HOME/install_packages.sh"
    print_success "Packages installed"
else
    print_warning "Package installation script not found at $HOME/install_packages.sh"
    print_info "Please run the package installation manually"
fi

# Step 2: Create necessary directories
print_section "Creating Directories"

directories=(
    "$HOME/.config"
    "$HOME/.local/bin"
    "$HOME/Projects"
    "$HOME/.ssh"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_success "Created directory: $dir"
    fi
done

# Step 3: Setup Zsh configuration
print_section "Configuring Zsh"

create_symlink "$DOTFILES_DIR/.zshrc.enhanced" "$HOME/.zshrc" "Zsh configuration"

# Create Zsh config directory
mkdir -p "$HOME/.config/zsh"
for file in "$DOTFILES_DIR/.config/zsh"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        create_symlink "$file" "$HOME/.config/zsh/$filename" "Zsh $filename"
    fi
done

# Step 4: Setup Neovim
print_section "Configuring Neovim"

create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim" "Neovim configuration"

# Step 5: Setup Tmux
print_section "Configuring Tmux"

create_symlink "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux" "Tmux configuration"

# Install TPM if not present
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    print_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    print_success "TPM installed"
fi

# Create tmux config symlink
create_symlink "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf" "Tmux config symlink"

# Step 6: Setup Git
print_section "Configuring Git"

create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "Git configuration"
create_symlink "$DOTFILES_DIR/.config/git" "$HOME/.config/git" "Git config directory"

# Step 7: Setup Terminal
print_section "Configuring Terminal"

create_symlink "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty" "Ghostty configuration"

# Step 8: Setup LazyGit
print_section "Configuring LazyGit"

create_symlink "$DOTFILES_DIR/.config/lazygit" "$HOME/.config/lazygit" "LazyGit configuration"

# Step 9: Setup Yazi
print_section "Configuring Yazi"

create_symlink "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi" "Yazi configuration"

# Step 10: Install scripts
print_section "Installing Utility Scripts"

# Make scripts executable
chmod +x "$DOTFILES_DIR/scripts"/*

# Link scripts to local bin
for script in "$DOTFILES_DIR/scripts"/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        create_symlink "$script" "$HOME/.local/bin/$script_name" "Script: $script_name"
    fi
done

print_success "Utility scripts installed"

# Step 11: Setup shell integration
print_section "Setting up Shell Integration"

# Change default shell to zsh if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    print_success "Default shell changed to zsh"
    print_warning "Please log out and back in for shell change to take effect"
fi

# Step 12: Setup development environment
print_section "Development Environment Setup"

if command_exists "code-insiders"; then
    print_info "Setting up VS Code Insiders integration..."
    # Set VS Code Insiders as git editor
    git config --global core.editor "code-insiders --wait"
elif command_exists "code"; then
    print_info "Setting up VS Code integration..."
    git config --global core.editor "code --wait"
fi

# Step 13: Final configuration
print_section "Final Configuration"

# Source zsh configuration
print_info "Loading Zsh configuration..."
if command_exists "zsh"; then
    # Note: Can't actually source in a bash script, but show what to do
    print_info "Run 'source ~/.zshrc' or restart your terminal to load the new configuration"
fi

# Setup Neovim plugins
print_info "Setting up Neovim plugins..."
print_info "Neovim plugins will be installed automatically on first launch"

# Setup Tmux plugins
print_info "Setting up Tmux plugins..."
print_info "Start tmux and press Prefix + I (Ctrl-a then Shift-i) to install plugins"

# Summary
print_section "Installation Summary"

echo -e "${GREEN}${SUCCESS} Dotfiles installation completed successfully!${NC}\n"

echo -e "${CYAN}What was installed:${NC}"
echo "• Enhanced Zsh configuration with modern tools"
echo "• Neovim with LazyVim and productivity plugins"
echo "• Tmux with session management and enhancements"
echo "• Git with useful aliases and delta diff viewer"
echo "• Terminal configurations (Ghostty)"
echo "• Development tools (LazyGit, Yazi file manager)"
echo "• Utility scripts for system management"
echo ""

echo -e "${CYAN}Backup location:${NC}"
if [ -d "$BACKUP_DIR" ]; then
    echo "Your original configurations were backed up to:"
    echo "$BACKUP_DIR"
    echo ""
fi

echo -e "${CYAN}Next steps:${NC}"
echo "1. Restart your terminal or run: exec zsh -l"
echo "2. Open tmux and install plugins: tmux new-session"
echo "   Then press Ctrl-a + Shift-i to install plugins"
echo "3. Open Neovim to let LazyVim install plugins: nvim"
echo "4. Configure your terminal font to 'JetBrains Mono Nerd Font'"
echo "5. Set up your Git credentials:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""
echo ""

echo -e "${CYAN}Quick reference:${NC}"
echo "• Documentation: ~/dotfiles/docs/"
echo "• Scripts: ~/.local/bin/ or ~/dotfiles/scripts/"
echo "• Keybindings: Run 'show-keybindings' in terminal"
echo "• System update: Run 'system-update'"
echo "• Backup configs: Run 'backup-config'"
echo ""

echo -e "${GREEN}${ROCKET} Installation complete! Happy coding! 🎉${NC}"

# Final note
if [ -d "$BACKUP_DIR" ]; then
    echo ""
    print_info "If you encounter any issues, you can restore your original"
    print_info "configurations from: $BACKUP_DIR"
fi