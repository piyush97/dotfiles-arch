#!/bin/bash

# Stow-based Dotfiles Installation Script
# Modern symlink management with GNU Stow

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
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# Available Stow packages
PACKAGES=(
    "zsh"
    "nvim"
    "tmux"
    "git"
    "ghostty"
    "lazygit"
    "yazi"
    "scripts"
    "kde"
)

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

# Function to check if Stow is installed
check_stow() {
    if ! command_exists "stow"; then
        print_error "GNU Stow is not installed!"
        print_info "Install it with: sudo pacman -S stow"
        exit 1
    fi
}

# Function to backup existing file/directory
backup_if_exists() {
    local file="$1"
    local backup_name="$2"
    
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        print_info "Backing up existing $backup_name..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$file" "$BACKUP_DIR/"
        print_success "Backed up $backup_name to $BACKUP_DIR"
        return 0
    fi
    return 1
}

# Function to unstow package (remove symlinks)
unstow_package() {
    local package="$1"
    if [ -d "$DOTFILES_DIR/$package" ]; then
        print_info "Removing existing symlinks for $package..."
        stow -D -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>/dev/null || true
    fi
}

# Function to stow package (create symlinks)
stow_package() {
    local package="$1"
    local description="$2"
    
    if [ ! -d "$DOTFILES_DIR/$package" ]; then
        print_warning "Package '$package' not found, skipping..."
        return 1
    fi
    
    print_info "Installing $description..."
    
    # First, unstow to clean up any existing symlinks
    unstow_package "$package"
    
    # Check for conflicts and backup if necessary
    local conflicts=()
    while IFS= read -r -d '' file; do
        local target="${file#$DOTFILES_DIR/$package/}"
        local dest="$HOME/$target"
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            conflicts+=("$dest")
        fi
    done < <(find "$DOTFILES_DIR/$package" -type f -print0)
    
    # Backup conflicting files
    for conflict in "${conflicts[@]}"; do
        local relative_path="${conflict#$HOME/}"
        backup_if_exists "$conflict" "$relative_path"
        rm -rf "$conflict"
    done
    
    # Stow the package
    if stow -d "$DOTFILES_DIR" -t "$HOME" "$package"; then
        print_success "$description installed successfully"
        return 0
    else
        print_error "Failed to install $description"
        return 1
    fi
}

# Function to show usage
show_usage() {
    echo -e "${CYAN}${ROCKET} Stow-based Dotfiles Installation${NC}"
    echo ""
    echo "Usage: $0 [options] [packages...]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -l, --list      List available packages"
    echo "  -i, --install   Install specified packages (default: all)"
    echo "  -r, --remove    Remove specified packages"
    echo "  -f, --force     Force installation without prompts"
    echo "  --dry-run       Show what would be done without making changes"
    echo ""
    echo "Available packages:"
    for pkg in "${PACKAGES[@]}"; do
        echo "  • $pkg"
    done
    echo ""
    echo "Examples:"
    echo "  $0                    # Install all packages"
    echo "  $0 zsh nvim tmux     # Install specific packages"
    echo "  $0 -r zsh           # Remove zsh package"
    echo "  $0 -l               # List packages"
}

# Function to list packages
list_packages() {
    echo -e "${CYAN}${PACKAGE} Available Stow Packages:${NC}\n"
    
    for pkg in "${PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$pkg" ]; then
            echo -e "${GREEN}✓${NC} $pkg"
            # Show what files are managed
            find "$DOTFILES_DIR/$pkg" -type f | head -3 | while read file; do
                local target="${file#$DOTFILES_DIR/$pkg/}"
                echo -e "    → ~/$target"
            done
            local count=$(find "$DOTFILES_DIR/$pkg" -type f | wc -l)
            if [ "$count" -gt 3 ]; then
                echo -e "    ... and $((count - 3)) more files"
            fi
            echo ""
        else
            echo -e "${YELLOW}⊘${NC} $pkg (not found)"
        fi
    done
}

# Function to validate packages
validate_packages() {
    local packages=("$@")
    local valid_packages=()
    
    for pkg in "${packages[@]}"; do
        if [[ " ${PACKAGES[@]} " =~ " $pkg " ]]; then
            if [ -d "$DOTFILES_DIR/$pkg" ]; then
                valid_packages+=("$pkg")
            else
                print_warning "Package '$pkg' directory not found, skipping..."
            fi
        else
            print_error "Unknown package: $pkg"
            print_info "Available packages: ${PACKAGES[*]}"
            return 1
        fi
    done
    
    if [ ${#valid_packages[@]} -eq 0 ]; then
        print_error "No valid packages specified"
        return 1
    fi
    
    echo "${valid_packages[@]}"
}

# Parse command line arguments
INSTALL_MODE=true
REMOVE_MODE=false
FORCE_INSTALL=false
DRY_RUN=false
LIST_ONLY=false
INSTALL_PACKAGES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -l|--list)
            LIST_ONLY=true
            shift
            ;;
        -i|--install)
            INSTALL_MODE=true
            REMOVE_MODE=false
            shift
            ;;
        -r|--remove)
            INSTALL_MODE=false
            REMOVE_MODE=true
            shift
            ;;
        -f|--force)
            FORCE_INSTALL=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            INSTALL_PACKAGES+=("$1")
            shift
            ;;
    esac
done

# Welcome message
echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║        🔗 Stow-based Dotfiles Management System             ║
║                                                              ║
║     • Clean symlink management with GNU Stow                ║
║     • Modular package installation                          ║
║     • Easy backup and restoration                           ║
║     • Conflict detection and resolution                     ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# Check prerequisites
check_stow

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# List packages mode
if [ "$LIST_ONLY" = true ]; then
    list_packages
    exit 0
fi

# Determine packages to process
if [ ${#INSTALL_PACKAGES[@]} -eq 0 ]; then
    # No packages specified, use all
    TARGET_PACKAGES=("${PACKAGES[@]}")
else
    # Validate specified packages
    if ! TARGET_PACKAGES=($(validate_packages "${INSTALL_PACKAGES[@]}")); then
        exit 1
    fi
fi

# Dry run mode
if [ "$DRY_RUN" = true ]; then
    print_section "Dry Run - Showing what would be done"
    
    if [ "$INSTALL_MODE" = true ]; then
        echo "Would install packages: ${TARGET_PACKAGES[*]}"
    elif [ "$REMOVE_MODE" = true ]; then
        echo "Would remove packages: ${TARGET_PACKAGES[*]}"
    fi
    
    for pkg in "${TARGET_PACKAGES[@]}"; do
        if [ -d "$pkg" ]; then
            echo ""
            echo "Package: $pkg"
            find "$pkg" -type f | while read file; do
                local target="${file#$pkg/}"
                if [ "$INSTALL_MODE" = true ]; then
                    echo "  Link: ~/$target → $DOTFILES_DIR/$file"
                else
                    echo "  Remove: ~/$target"
                fi
            done
        fi
    done
    
    print_info "Dry run complete. Use without --dry-run to proceed."
    exit 0
fi

# Confirmation prompt
if [ "$FORCE_INSTALL" = false ]; then
    if [ "$INSTALL_MODE" = true ]; then
        echo -e "${YELLOW}This will install the following packages using Stow:${NC}"
        echo "${TARGET_PACKAGES[*]}"
    elif [ "$REMOVE_MODE" = true ]; then
        echo -e "${YELLOW}This will remove the following packages:${NC}"
        echo "${TARGET_PACKAGES[*]}"
    fi
    echo -e "${YELLOW}Existing files will be backed up to: $BACKUP_DIR${NC}"
    echo ""
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Operation cancelled"
        exit 0
    fi
fi

# Process packages
if [ "$INSTALL_MODE" = true ]; then
    print_section "Installing Dotfiles Packages"
    
    failed_packages=()
    successful_packages=()
    
    for pkg in "${TARGET_PACKAGES[@]}"; do
        case "$pkg" in
            "zsh")
                if stow_package "$pkg" "Zsh configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "nvim")
                if stow_package "$pkg" "Neovim configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "tmux")
                if stow_package "$pkg" "Tmux configuration"; then
                    successful_packages+=("$pkg")
                    # Create additional symlink for .tmux.conf
                    if [ ! -L "$HOME/.tmux.conf" ]; then
                        ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
                        print_success "Created .tmux.conf symlink"
                    fi
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "git")
                if stow_package "$pkg" "Git configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "ghostty")
                if stow_package "$pkg" "Ghostty terminal configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "lazygit")
                if stow_package "$pkg" "LazyGit configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "yazi")
                if stow_package "$pkg" "Yazi file manager configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "scripts")
                if stow_package "$pkg" "Utility scripts"; then
                    # Make scripts executable
                    find "$HOME/.local/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            "kde")
                if stow_package "$pkg" "KDE Plasma configuration"; then
                    successful_packages+=("$pkg")
                else
                    failed_packages+=("$pkg")
                fi
                ;;
            *)
                print_warning "Unknown package: $pkg"
                failed_packages+=("$pkg")
                ;;
        esac
    done
    
elif [ "$REMOVE_MODE" = true ]; then
    print_section "Removing Dotfiles Packages"
    
    for pkg in "${TARGET_PACKAGES[@]}"; do
        print_info "Removing $pkg..."
        unstow_package "$pkg"
        print_success "$pkg removed"
    done
fi

# Summary
print_section "Installation Summary"

if [ "$INSTALL_MODE" = true ]; then
    if [ ${#successful_packages[@]} -gt 0 ]; then
        echo -e "${GREEN}${SUCCESS} Successfully installed packages:${NC}"
        for pkg in "${successful_packages[@]}"; do
            echo "  • $pkg"
        done
        echo ""
    fi
    
    if [ ${#failed_packages[@]} -gt 0 ]; then
        echo -e "${RED}${ERROR} Failed to install packages:${NC}"
        for pkg in "${failed_packages[@]}"; do
            echo "  • $pkg"
        done
        echo ""
    fi
    
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${CYAN}📦 Backup location:${NC} $BACKUP_DIR"
        echo ""
    fi
    
    echo -e "${CYAN}🔗 Stow Management:${NC}"
    echo "• View installed packages: stow -n -v -t ~ *"
    echo "• Remove package: stow -D -t ~ package-name"
    echo "• Reinstall package: stow -R -t ~ package-name"
    echo ""
    
    echo -e "${CYAN}Next steps:${NC}"
    if [[ " ${successful_packages[@]} " =~ " zsh " ]]; then
        echo "1. Restart your terminal or run: exec zsh -l"
    fi
    if [[ " ${successful_packages[@]} " =~ " tmux " ]]; then
        echo "2. Install tmux plugins: tmux new-session, then Ctrl-a + Shift-i"
    fi
    if [[ " ${successful_packages[@]} " =~ " nvim " ]]; then
        echo "3. Open Neovim to install plugins: nvim"
    fi
    
    if [ ${#successful_packages[@]} -gt 0 ] && [ ${#failed_packages[@]} -eq 0 ]; then
        echo ""
        echo -e "${GREEN}${ROCKET} All packages installed successfully! 🎉${NC}"
    fi
fi

echo ""
print_success "Stow operation completed!"