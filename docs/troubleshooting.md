# 🔧 Troubleshooting Guide

Common issues and solutions for the dotfiles setup.

## 🚨 Installation Issues

### Package Installation Fails

**Problem**: Package installation script fails with permission errors.

**Solution**:
```bash
# Ensure sudo access
sudo -v

# Update package database
sudo pacman -Sy

# Run installation script again
bash ~/install_packages.sh
```

**Problem**: AUR packages fail to install.

**Solution**:
```bash
# Install yay if not present
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Try AUR installation again
yay -S package-name
```

### Git Clone Fails

**Problem**: Cannot clone the dotfiles repository.

**Solution**:
```bash
# Check internet connection
ping google.com

# Use HTTPS instead of SSH
git clone https://github.com/username/dotfiles.git ~/dotfiles

# If behind corporate firewall
git config --global http.proxy http://proxy.company.com:port
```

## 🐚 Shell Issues

### Zsh Not Loading Properly

**Problem**: Zsh configuration not loading or showing errors.

**Solution**:
```bash
# Check if zsh is installed
which zsh

# Check if zsh is the default shell
echo $SHELL

# Change default shell if needed
chsh -s $(which zsh)

# Source configuration manually
source ~/.zshrc

# Check for syntax errors
zsh -n ~/.zshrc
```

### Zinit Installation Problems

**Problem**: Zinit plugins not loading or installation fails.

**Solution**:
```bash
# Remove Zinit and reinstall
rm -rf ~/.local/share/zinit

# Reinstall Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Reload configuration
source ~/.zshrc

# Update plugins
zinit update --all
```

### Command Not Found Errors

**Problem**: Custom aliases or functions not working.

**Solution**:
```bash
# Check if config files are sourced
ls -la ~/.config/zsh/

# Manually source configuration files
source ~/.config/zsh/enhanced-aliases.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/keybindings.zsh

# Check PATH
echo $PATH

# Add missing paths
export PATH="$HOME/.local/bin:$PATH"
```

## 📝 Neovim Issues

### LazyVim Not Loading

**Problem**: Neovim shows errors on startup or LazyVim not configured.

**Solution**:
```bash
# Check Neovim version (should be 0.9+)
nvim --version

# Remove existing configuration
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Restore configuration
cp -r ~/dotfiles/.config/nvim ~/.config/

# Start Neovim and let Lazy install plugins
nvim
```

### LSP Servers Not Working

**Problem**: Language servers not providing completions or diagnostics.

**Solution**:
```bash
# Open Neovim and check LSP status
nvim
:LspInfo

# Install missing language servers
:LspInstall typescript
:LspInstall lua_ls
:LspInstall pyright

# Check Mason for available servers
:Mason
```

### Plugin Installation Fails

**Problem**: Neovim plugins fail to install or update.

**Solution**:
```bash
# Open Neovim and update plugins
nvim
:Lazy sync

# Check for errors
:Lazy log

# Clear plugin cache
rm -rf ~/.local/share/nvim/lazy
:Lazy sync
```

## 🔀 Tmux Issues

### Tmux Not Starting

**Problem**: Tmux fails to start or shows errors.

**Solution**:
```bash
# Check tmux version
tmux -V

# Kill all tmux sessions
tmux kill-server

# Check configuration syntax
tmux source-file ~/.config/tmux/tmux.conf

# Start with minimal config
tmux -f /dev/null
```

### TPM Plugins Not Loading

**Problem**: Tmux plugins not installed or working.

**Solution**:
```bash
# Install TPM if missing
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Install plugins (inside tmux)
# Press Prefix + I (Ctrl-a then Shift-i)

# Update plugins
# Press Prefix + U

# Reload tmux configuration
tmux source-file ~/.config/tmux/tmux.conf
```

### Copy-Paste Not Working

**Problem**: Tmux copy-paste doesn't work with system clipboard.

**Solution**:
```bash
# Install clipboard utility
sudo pacman -S xclip  # or xsel

# Check if running in X11 or Wayland
echo $XDG_SESSION_TYPE

# For Wayland, install wl-clipboard
sudo pacman -S wl-clipboard

# Test clipboard
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

## 🎨 Terminal Issues

### Fonts Not Displaying Properly

**Problem**: Icons, symbols, or fonts not rendering correctly.

**Solution**:
```bash
# Install Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv

# Configure terminal to use the font
# Set font to "JetBrains Mono Nerd Font" in terminal settings
```

### Colors Not Working

**Problem**: Terminal colors appear wrong or not showing.

**Solution**:
```bash
# Check terminal support
echo $TERM
echo $COLORTERM

# Test 256 color support
curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash

# Set correct terminal variables
export TERM=xterm-256color
export COLORTERM=truecolor

# Add to shell configuration
echo 'export TERM=xterm-256color' >> ~/.zshrc
echo 'export COLORTERM=truecolor' >> ~/.zshrc
```

### Ghostty Issues

**Problem**: Ghostty terminal not starting or configuration not loading.

**Solution**:
```bash
# Check if Ghostty is installed
which ghostty

# Check configuration file
ghostty --print-config

# Test with minimal config
ghostty --config-override font-size=12

# Reset configuration
mv ~/.config/ghostty/config ~/.config/ghostty/config.bak
```

## 🔧 Git Issues

### Git Aliases Not Working

**Problem**: Custom git aliases not recognized.

**Solution**:
```bash
# Check git configuration
git config --global --list | grep alias

# Source git configuration
git config --global include.path ~/dotfiles/.gitconfig

# Check specific alias
git config --global alias.st
```

### Delta Not Working

**Problem**: Git diff not showing enhanced output with delta.

**Solution**:
```bash
# Install delta
sudo pacman -S git-delta

# Check if delta is in PATH
which delta

# Test delta
echo -e "line1\nline2" | delta

# Configure git to use delta
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
```

### Lazygit Configuration Issues

**Problem**: Lazygit not using custom configuration.

**Solution**:
```bash
# Check configuration location
lazygit --print-config-dir

# Copy configuration
mkdir -p ~/.config/lazygit
cp ~/dotfiles/.config/lazygit/config.yml ~/.config/lazygit/

# Check for YAML syntax errors
yamllint ~/.config/lazygit/config.yml
```

## 🌐 Network Issues

### Slow Downloads

**Problem**: Package installations or git operations are slow.

**Solution**:
```bash
# Update mirror list
sudo reflector --country 'United States' --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Use different git protocol
git config --global url."https://github.com/".insteadOf git@github.com:

# Check network speed
speedtest-cli
```

### Proxy Issues

**Problem**: Behind corporate firewall or proxy.

**Solution**:
```bash
# Configure git proxy
git config --global http.proxy http://proxy.company.com:port
git config --global https.proxy https://proxy.company.com:port

# Configure npm proxy
npm config set proxy http://proxy.company.com:port
npm config set https-proxy https://proxy.company.com:port

# Configure environment variables
export HTTP_PROXY=http://proxy.company.com:port
export HTTPS_PROXY=https://proxy.company.com:port
```

## 🔍 Debugging Tools

### Check System Status

```bash
# System information
system-info

# Check running services
systemctl --user status

# Check disk space
df -h

# Check memory usage
free -h

# Check for errors in logs
journalctl --user -xe
```

### Verbose Logging

```bash
# Zsh debug mode
zsh -x

# Git verbose output
git config --global core.preloadindex true
git config --global core.fscache true

# Neovim debug
nvim --cmd 'set verbose=15'
```

### Reset Configurations

```bash
# Backup current configs
backup-config

# Reset to defaults
mv ~/.zshrc ~/.zshrc.bak
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/tmux ~/.config/tmux.bak

# Restore from dotfiles
cp ~/dotfiles/.zshrc.enhanced ~/.zshrc
cp -r ~/dotfiles/.config/nvim ~/.config/
cp -r ~/dotfiles/.config/tmux ~/.config/
```

## 📞 Getting Help

### Check Documentation

1. Read the specific tool documentation:
   - `man zsh`
   - `:help` in Neovim
   - `tmux list-keys` in tmux

2. Check online resources:
   - [LazyVim Documentation](https://lazyvim.org)
   - [Tmux Manual](https://man7.org/linux/man-pages/man1/tmux.1.html)
   - [Zsh Manual](https://zsh.sourceforge.io/Doc/)

### Report Issues

If you can't resolve an issue:

1. Check existing issues in the repository
2. Create a new issue with:
   - System information (`uname -a`)
   - Error messages (full output)
   - Steps to reproduce
   - What you've tried

### Common Commands for Debugging

```bash
# Check shell
echo $SHELL
ps -p $$

# Check environment
env | grep -E "(EDITOR|TERM|PATH)"

# Check running processes
ps aux | grep -E "(tmux|nvim|zsh)"

# Check configuration files
ls -la ~/.config/
ls -la ~/dotfiles/

# Test minimal setup
zsh --no-rcs
tmux -f /dev/null
nvim --clean
```

## 💡 Prevention Tips

1. **Regular Updates**: Run `system-update` weekly
2. **Backup Configs**: Use `backup-config` before major changes
3. **Version Control**: Keep dotfiles in git and commit changes
4. **Test Changes**: Test configurations in a clean environment first
5. **Documentation**: Document custom modifications

---

**Remember**: Most issues can be resolved by carefully reading error messages and checking the logs. When in doubt, start fresh with a clean configuration!