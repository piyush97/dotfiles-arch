# 🔗 GNU Stow Dotfiles Management Guide

This guide explains how to use GNU Stow to manage your dotfiles with clean, organized symlinks.

## 🤔 What is GNU Stow?

GNU Stow is a symlink farm manager that makes it easy to manage dotfiles by creating symbolic links from organized package directories to your home directory.

### Benefits of Using Stow:

- **Clean Organization**: Each tool has its own directory
- **Easy Management**: Install/remove configurations with simple commands
- **No Conflicts**: Stow detects and handles conflicts gracefully
- **Backup Friendly**: Original files are preserved
- **Selective Installation**: Install only what you need

## 📁 Directory Structure

```
dotfiles/
├── zsh/
│   ├── .zshrc                    → ~/.zshrc
│   └── .config/
│       └── zsh/                  → ~/.config/zsh/
├── nvim/
│   └── .config/
│       └── nvim/                 → ~/.config/nvim/
├── tmux/
│   └── .config/
│       └── tmux/                 → ~/.config/tmux/
├── git/
│   ├── .gitconfig                → ~/.gitconfig
│   └── .config/
│       └── git/                  → ~/.config/git/
├── ghostty/
│   └── .config/
│       └── ghostty/              → ~/.config/ghostty/
├── lazygit/
│   └── .config/
│       └── lazygit/              → ~/.config/lazygit/
├── yazi/
│   └── .config/
│       └── yazi/                 → ~/.config/yazi/
└── scripts/
    └── .local/
        └── bin/                  → ~/.local/bin/
```

## 🚀 Quick Start

### Install All Packages

```bash
cd ~/dotfiles
./install-stow.sh
```

### Install Specific Packages

```bash
./install-stow.sh zsh nvim tmux
```

### List Available Packages

```bash
./install-stow.sh --list
```

## 📋 Available Packages

| Package | Description | Key Files |
|---------|-------------|-----------|
| `zsh` | Shell configuration | `.zshrc`, `.config/zsh/` |
| `nvim` | Neovim editor | `.config/nvim/` |
| `tmux` | Terminal multiplexer | `.config/tmux/` |
| `git` | Git configuration | `.gitconfig`, `.config/git/` |
| `ghostty` | Terminal emulator | `.config/ghostty/` |
| `lazygit` | Git TUI | `.config/lazygit/` |
| `yazi` | File manager | `.config/yazi/` |
| `scripts` | Utility scripts | `.local/bin/` |

## 🛠️ Common Operations

### Install a Single Package

```bash
cd ~/dotfiles
stow zsh
```

### Remove a Package

```bash
cd ~/dotfiles
stow -D zsh
```

### Reinstall a Package (restow)

```bash
cd ~/dotfiles
stow -R zsh
```

### Dry Run (See What Would Happen)

```bash
cd ~/dotfiles
stow -n -v zsh
```

### Remove All Packages

```bash
./install-stow.sh --remove zsh nvim tmux git ghostty lazygit yazi scripts
```

## 🔍 Understanding Stow Commands

### Basic Stow Syntax

```bash
stow [options] [packages...]
```

### Important Options

| Option | Description |
|--------|-------------|
| `-n` | Dry run (don't actually do anything) |
| `-v` | Verbose output |
| `-D` | Delete/unstow package |
| `-R` | Restow (delete then stow) |
| `-t` | Target directory (default: parent of stow dir) |
| `-d` | Stow directory (where packages are stored) |

### Examples

```bash
# Install with verbose output
stow -v zsh

# Dry run to see what would be linked
stow -n -v nvim

# Unstow with verbose output
stow -D -v tmux

# Restow (useful after updating files)
stow -R -v git

# Target a different directory
stow -t /some/other/dir package
```

## 🚨 Conflict Resolution

### What Happens During Conflicts?

When Stow encounters existing files that aren't symlinks, it cannot proceed. Our installation script handles this by:

1. **Detecting conflicts** before stowing
2. **Backing up existing files** to a timestamped directory
3. **Removing conflicting files**
4. **Creating clean symlinks**

### Manual Conflict Resolution

If you encounter conflicts with manual Stow commands:

```bash
# Check what conflicts exist
stow -n -v zsh

# Handle conflicts manually
mv ~/.zshrc ~/.zshrc.backup
stow zsh
```

## 📦 Adding New Packages

### 1. Create Package Directory

```bash
mkdir -p ~/dotfiles/myapp/.config
```

### 2. Add Configuration Files

```bash
# Copy your config to the package directory
cp -r ~/.config/myapp ~/dotfiles/myapp/.config/
```

### 3. Test the Package

```bash
cd ~/dotfiles
stow -n -v myapp  # Dry run first
stow myapp        # Actually install
```

### 4. Update Installation Script

Add your package to the `PACKAGES` array in `install-stow.sh`:

```bash
PACKAGES=(
    "zsh"
    "nvim"
    # ... existing packages ...
    "myapp"  # Add your package here
)
```

## 🔄 Maintenance

### Check Installed Packages

```bash
cd ~/dotfiles
find . -name ".*" -type d | grep -v "/.git"
```

### Verify Symlinks

```bash
# Check if files are properly linked
ls -la ~/.zshrc
ls -la ~/.config/nvim

# Find broken symlinks
find ~ -type l -exec test ! -e {} \; -print 2>/dev/null
```

### Update Configurations

When you modify files in your home directory that are managed by Stow, the changes are automatically reflected in your dotfiles repository because they're symlinked.

```bash
# Example: Edit zsh config
nvim ~/.zshrc  # This edits ~/dotfiles/zsh/.zshrc

# Commit changes
cd ~/dotfiles
git add zsh/.zshrc
git commit -m "Update zsh configuration"
```

## 🚀 Advanced Usage

### Selective File Installation

You can create multiple packages for the same application:

```bash
dotfiles/
├── nvim-basic/
│   └── .config/nvim/init.lua
└── nvim-full/
    └── .config/nvim/
        ├── init.lua
        ├── lua/
        └── after/
```

### Environment-Specific Configurations

```bash
dotfiles/
├── zsh-common/
│   └── .config/zsh/common.zsh
├── zsh-work/
│   └── .config/zsh/work.zsh
└── zsh-personal/
    └── .config/zsh/personal.zsh
```

### Using Stow with Multiple Machines

```bash
# Different packages for different machines
./install-stow.sh zsh nvim git     # Minimal setup
./install-stow.sh $(cat packages.txt)  # From file
```

## 🆘 Troubleshooting

### Package Won't Install

```bash
# Check for conflicts
stow -n -v package-name

# Force reinstall
stow -D package-name
stow package-name
```

### Broken Symlinks

```bash
# Find and remove broken symlinks
find ~ -type l -exec test ! -e {} \; -delete 2>/dev/null

# Reinstall packages
./install-stow.sh --force
```

### Permission Issues

```bash
# Make sure you own the target directories
sudo chown -R $USER:$USER ~/.config

# Fix script permissions
chmod +x ~/dotfiles/scripts/.local/bin/*
```

## 💡 Tips and Best Practices

### 1. Always Use Dry Run First

```bash
stow -n -v package-name
```

### 2. Keep Packages Focused

Each package should contain related configurations only.

### 3. Use Version Control

```bash
cd ~/dotfiles
git add .
git commit -m "Add new configuration"
```

### 4. Document Changes

Keep track of what each package does and any special requirements.

### 5. Test on Clean Systems

Periodically test your dotfiles on a fresh system to ensure everything works.

## 🔗 Useful Links

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Stow GitHub Repository](https://github.com/aspiers/stow)
- [Managing dotfiles with GNU Stow](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)

---

**Happy Stowing! 🎉**