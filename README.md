# 🚀 Modern Arch Linux Dotfiles

> **A beautifully crafted, macOS-inspired development environment for Arch Linux**

[![GitHub stars](https://img.shields.io/github/stars/piyush97/dotfiles-arch?style=social)](https://github.com/piyush97/dotfiles-arch)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff)](https://archlinux.org/)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red.svg)](https://github.com/piyush97/dotfiles-arch)

**Transform your Arch Linux into a productivity powerhouse with this carefully curated collection of dotfiles. Designed for developers who appreciate both beauty and functionality.**

---

## ✨ What Makes This Special?

### 🎨 **Visual Excellence**
- **Tokyo Night** theme across all applications for visual consistency
- **JetBrains Mono Nerd Font** with perfect icon rendering
- **Powerlevel10k** prompt with intelligent git integration
- Carefully crafted color schemes that reduce eye strain

### 🍎 **macOS-Inspired Workflow**
- Familiar keyboard shortcuts (`Alt` as `Cmd` equivalent)
- Intuitive window management and navigation
- Seamless system clipboard integration
- Natural gesture-like terminal interactions

### ⚡ **Developer-Focused**
- **LazyVim** - Lightning-fast Neovim with LSP support
- **Tmux** - Powerful session management with persistent workflows
- **Modern CLI tools** - Enhanced replacements for traditional Unix commands
- **Git workflow optimization** - Beautiful diffs with delta and lazygit

### 🛠️ **Easy Management**
- **GNU Stow** for clean, conflict-free symlink management
- **Modular packages** - Install only what you need
- **Automated backups** - Never lose your configurations
- **Cross-machine sync** - Identical setup across all your devices

## 📁 Structure

```
dotfiles/
├── .config/
│   ├── nvim/           # Neovim configuration (LazyVim)
│   ├── tmux/           # Tmux configuration and plugins
│   ├── git/            # Git configuration and global gitignore
│   ├── ghostty/        # Ghostty terminal configuration
│   ├── yazi/           # Yazi file manager configuration
│   ├── lazygit/        # Lazygit configuration
│   └── zsh/            # Extended Zsh configurations
├── scripts/            # Utility scripts
├── docs/               # Documentation
├── .gitconfig          # Global git configuration
├── .zshrc.enhanced     # Enhanced Zsh configuration
└── install.sh          # Automated installation script
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/piyush97/dotfiles-arch.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install Packages

Run the package installation script:

```bash
# Run the comprehensive package installer
bash install_packages.sh
```

### 3. Install Dotfiles

```bash
# Install all packages with Stow
bash install-stow.sh

# Or install specific packages only
bash install-stow.sh zsh nvim tmux git kde
```

### 4️⃣ **Restart & Enjoy**
```bash
# Restart your shell to load new configuration
exec zsh -l
```

## 📋 What's Included

### 🐚 Shell Configuration
- **Zsh** with Zinit plugin manager
- **Powerlevel10k** theme
- Enhanced aliases and functions
- macOS-like keybindings
- Intelligent history and completions

### 📝 Editor Setup
- **Neovim** with LazyVim distribution
- LSP support for multiple languages
- GitHub Copilot integration
- Fuzzy finding and file navigation
- Git integration

### 🔀 Terminal Multiplexer
- **Tmux** with TPM (Tmux Plugin Manager)
- Session persistence and restoration
- macOS-like navigation shortcuts
- Status bar with system information

### 🌊 Git Workflow
- Comprehensive git aliases
- Delta for enhanced diffs
- Lazygit for terminal-based git operations
- Global gitignore for common files

### 📱 Terminal
- **Ghostty** terminal with Tokyo Night theme
- Font ligatures and emoji support
- Optimized for development workflows

### 🎨 KDE Plasma Desktop
- **Tokyo Night** color scheme integration
- **macOS-inspired** keyboard shortcuts and behavior
- **Modern window management** with smooth animations
- **Dock-style panel** with clean, minimal design

## ⚡ Key Features

### macOS-Like Keybindings

| Shortcut | Action |
|----------|--------|
| `Alt + A` | Beginning of line |
| `Alt + E` | End of line |
| `Alt + ←/→` | Move word by word |
| `Alt + ↑` | Parent directory |
| `Alt + S` | Git status |
| `Alt + G` | Quick directory jump |
| `Ctrl + R` | FZF history search |
| `Ctrl + T` | FZF file picker |

### Enhanced Aliases

```bash
# Navigation
alias ...='cd ../..'
alias proj='cd ~/Projects'
alias config='cd ~/.config'

# Git shortcuts
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias lg='lazygit'

# Enhanced ls
alias ls='lsd -F --group-dirs first'
alias ll='lsd -lahF --group-dirs first'
alias tree='lsd --tree'

# Development
alias v='nvim'
alias t='tmux'
alias py='python3'
```

### Useful Functions

```bash
# Create directory and cd into it
mkcd dirname

# Extract any archive
extract filename.tar.gz

# Fuzzy find and cd to directory
fcd

# Quick project setup
project my-app node

# System information
sysinfo

# Network speed test
speedtest
```

## 🛠️ Customization

### Personal Configuration

Create local configuration files that won't be tracked by git:

```bash
# Local Zsh configuration
~/.config/zsh/local.zsh

# Local functions
~/.config/zsh/local-functions.zsh

# Local keybindings
~/.config/zsh/local-keybindings.zsh
```

### Git Configuration

Update your personal git information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH Keys

Generate SSH keys for GitHub:

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## 🔧 Tools and Scripts

### System Management

```bash
# Update entire system
system-update

# Backup configurations
backup-config

# Setup development environment
dev-env-setup

# Create new project
new-project my-app react
```

### Development Workflow

```bash
# Start tmux session for current directory
tms

# Fuzzy find and edit files
fe

# Git branch switcher
fbr

# Kill process with fzf
fkill

# Weather information
wttr
```

## 🔗 Stow Management

This dotfiles setup uses GNU Stow for clean symlink management:

```bash
# List available packages
./install-stow.sh --list

# Install specific packages
./install-stow.sh zsh nvim tmux

# Remove packages
./install-stow.sh --remove tmux

# Manual stow commands
cd ~/dotfiles
stow zsh          # Install zsh package
stow -D nvim      # Remove nvim package
stow -R tmux      # Reinstall tmux package
```

## 📚 Documentation

- [Stow Management Guide](docs/stow-guide.md)
- [Keybindings Reference](docs/keybindings.md)
- [Tmux Guide](docs/tmux.md)
- [Neovim Configuration](docs/neovim.md)
- [Git Workflow](docs/git.md)
- [Troubleshooting](docs/troubleshooting.md)

## 🔄 Updates

Keep your dotfiles up to date:

```bash
cd ~/dotfiles
git pull origin main
bash install.sh
```

For system-wide updates:

```bash
system-update
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [LazyVim](https://lazyvim.org/) for the excellent Neovim configuration
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for the beautiful prompt
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) for the color scheme
- [Zinit](https://github.com/zdharma-continuum/zinit) for Zsh plugin management

## 📞 Support

If you encounter any issues or have questions:

1. Check the [troubleshooting guide](docs/troubleshooting.md)
2. Search existing [issues](https://github.com/piyush97/dotfiles/issues)
3. Create a new issue with detailed information

---

**Made with ❤️ for developers who appreciate beautiful, functional environments**