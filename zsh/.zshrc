#!/usr/bin/env zsh
# =====================================
# Enhanced Zsh Configuration
# macOS-inspired with productivity features
# =====================================

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =====================================
# Zinit Plugin Manager
# =====================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =====================================
# Theme and Plugins
# =====================================

# Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Essential plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Oh-My-Zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::extract

# Additional useful plugins
zinit light hlissner/zsh-autopair
zinit light MichaelAquilina/zsh-you-should-use
zinit light zdharma-continuum/fast-syntax-highlighting

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# =====================================
# Environment Variables
# =====================================

# Editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# Terminal
export TERMINAL=ghostty
export COLORTERM=truecolor

# Browser
export BROWSER=firefox

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Pagers
if command -v bat &> /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
else
    export PAGER=less
fi

# FZF Configuration
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border=rounded
        --info=inline
        --ansi
        --preview-window=right:60%:wrap
        --bind='ctrl-/:toggle-preview'
        --bind='ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
        --color=bg+:#3b4261
        --color=bg:#1a1b26
        --color=border:#7aa2f7
        --color=fg:#c0caf5
        --color=gutter:#1a1b26
        --color=header:#ff9e64
        --color=hl+:#2ac3de
        --color=hl:#2ac3de
        --color=info:#545c7e
        --color=marker:#ff007c
        --color=pointer:#ff007c
        --color=prompt:#2ac3de
        --color=query:#c0caf5
        --color=scrollbar:#7aa2f7
        --color=separator:#ff9e64
        --color=spinner:#ff007c
    "
    
    # Use fd for FZF file preview
    export FZF_CTRL_T_OPTS="
        --preview 'bat --style=numbers --color=always --line-range=:500 {}'
    "
    
    # Use tree for directory preview
    export FZF_ALT_C_OPTS="
        --preview 'lsd --tree --color=always --icon=always {} | head -200'
    "
fi

# =====================================
# Path Configuration
# =====================================

# Function to add to PATH safely
pathappend() {
    for ARG in "$@"; do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

pathprepend() {
    for ARG in "$@"; do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

# Add common paths
pathprepend "$HOME/bin" "$HOME/.local/bin" "$HOME/.bin"
pathappend "$HOME/.cargo/bin" "$HOME/go/bin"

# =====================================
# Zsh Options
# =====================================

# Directory navigation
setopt autocd              # Change directory by typing directory name
setopt auto_pushd          # Push directories onto stack
setopt pushd_ignore_dups   # Don't push duplicates
setopt pushdminus          # Exchange + and - for pushd/popd

# History
setopt appendhistory       # Append to history file
setopt sharehistory        # Share history between sessions
setopt hist_ignore_space   # Ignore commands starting with space
setopt hist_ignore_all_dups # Remove all duplicates
setopt hist_save_no_dups   # Don't save duplicates
setopt hist_ignore_dups    # Ignore consecutive duplicates
setopt hist_find_no_dups   # Don't show duplicates when searching
setopt hist_reduce_blanks  # Remove superfluous blanks
setopt hist_verify         # Show command before executing from history
setopt inc_append_history  # Add commands immediately

# Completion
setopt complete_in_word    # Complete from cursor position
setopt always_to_end       # Move cursor to end after completion
setopt menu_complete       # Auto-select first completion match
setopt list_packed         # Compact completion list

# Correction
setopt correct             # Correct commands
setopt correct_all         # Correct all arguments

# Globbing
setopt extended_glob       # Extended globbing
setopt glob_dots          # Include dotfiles in globbing
setopt no_case_glob       # Case-insensitive globbing

# Other options
setopt interactivecomments # Allow comments in interactive shell
setopt magicequalsubst     # Enable = expansion
setopt notify              # Report job status immediately
setopt numericglobsort     # Sort filenames numerically
setopt promptsubst         # Enable prompt substitution
setopt no_beep            # Disable beeping
setopt no_flow_control    # Disable flow control (^S/^Q)

# =====================================
# History Configuration
# =====================================

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# =====================================
# Completion System
# =====================================

# Initialize completion
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# Descriptions
zstyle ':completion:*:descriptions' format '%B%F{yellow}--- %d ---%f%b'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# FZF-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Docker completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# =====================================
# Load Custom Configurations
# =====================================

# Load aliases
[ -f ~/.config/zsh/enhanced-aliases.zsh ] && source ~/.config/zsh/enhanced-aliases.zsh

# Load functions
[ -f ~/.config/zsh/functions.zsh ] && source ~/.config/zsh/functions.zsh

# Load keybindings
[ -f ~/.config/zsh/keybindings.zsh ] && source ~/.config/zsh/keybindings.zsh

# Load local configuration
[ -f ~/.config/zsh/local.zsh ] && source ~/.config/zsh/local.zsh

# =====================================
# Tool Integrations
# =====================================

# FZF
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# Zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# =====================================
# Vi Mode Configuration
# =====================================

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

# =====================================
# Prompt Configuration
# =====================================

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =====================================
# Welcome Message
# =====================================

if command -v fastfetch &> /dev/null; then
    fastfetch
elif command -v neofetch &> /dev/null; then
    neofetch
fi

# =====================================
# Startup Commands
# =====================================

# Auto-update check for system
alias update-check='echo "Checking for updates..." && yay -Qu'

# Show todo list if it exists
[ -f ~/todo.md ] && echo "\n📝 Today's Tasks:" && head -5 ~/todo.md

# =====================================
# End of Configuration
# =====================================