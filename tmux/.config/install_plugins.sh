#!/bin/bash

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo "TPM installed! Press Prefix + I (Ctrl-a then Shift-i) inside tmux to install plugins"
else
    echo "TPM already installed"
fi

# Create symlink for tmux config if not exists
if [ ! -f "$HOME/.tmux.conf" ]; then
    ln -s "$HOME/dotfiles/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
    echo "Created symlink for tmux config"
fi

echo ""
echo "Tmux setup complete!"
echo ""
echo "Quick tmux shortcuts:"
echo "  Ctrl-a           - Prefix key"
echo "  Prefix + |       - Split vertically"
echo "  Prefix + -       - Split horizontally"
echo "  Alt + Arrow      - Navigate panes"
echo "  Shift + Arrow    - Navigate windows"
echo "  Prefix + c       - New window"
echo "  Prefix + ,       - Rename window"
echo "  Prefix + [       - Copy mode"
echo "  Prefix + r       - Reload config"
echo ""
echo "Remember to run 'tmux source ~/.tmux.conf' if tmux is already running"