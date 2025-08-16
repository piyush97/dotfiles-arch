#!/usr/bin/env zsh
# macOS-inspired keybindings for Zsh

# =====================================
# Vi Mode Configuration
# =====================================

# Enable vi mode
bindkey -v

# Reduce delay when switching modes
export KEYTIMEOUT=1

# =====================================
# macOS-like Keybindings
# =====================================

# Command + A -> Go to beginning of line (using Alt as Cmd substitute)
bindkey '^A' beginning-of-line
bindkey '\ea' beginning-of-line

# Command + E -> Go to end of line
bindkey '^E' end-of-line
bindkey '\ee' end-of-line

# Command + Left/Right -> Beginning/End of line
bindkey "^[[1;3D" beginning-of-line  # Alt+Left
bindkey "^[[1;3C" end-of-line        # Alt+Right

# Option + Left/Right -> Move word by word (Alt+Arrow)
bindkey "^[[1;5D" backward-word      # Ctrl+Left
bindkey "^[[1;5C" forward-word       # Ctrl+Right
bindkey '\e[1;3D' backward-word      # Alt+Left
bindkey '\e[1;3C' forward-word       # Alt+Right

# Command + Delete -> Delete word before cursor
bindkey '^W' backward-kill-word
bindkey '\ed' delete-word

# Command + K -> Kill to end of line
bindkey '^K' kill-line

# Command + U -> Kill to beginning of line
bindkey '^U' backward-kill-line

# Command + Z -> Undo
bindkey '^Z' undo
bindkey '\ez' undo

# Command + Shift + Z -> Redo
bindkey '^Y' redo
bindkey '\eZ' redo

# =====================================
# History Navigation
# =====================================

# Up/Down arrows for history search based on current input
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Ctrl+R for reverse history search (like bash)
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Page Up/Down for history
bindkey '^[[5~' history-beginning-search-backward
bindkey '^[[6~' history-beginning-search-forward

# =====================================
# Text Editing
# =====================================

# Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Delete key
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# Insert key
bindkey '^[[2~' overwrite-mode

# =====================================
# Completion
# =====================================

# Tab/Shift-Tab for menu completion
bindkey '^I' menu-complete
bindkey '^[[Z' reverse-menu-complete

# Ctrl+Space for completion
bindkey '^ ' autosuggest-accept

# =====================================
# FZF Integration Keybindings
# =====================================

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi

if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

# Custom FZF keybindings
if command -v fzf &> /dev/null; then
    # Ctrl+T -> File picker
    bindkey '^T' fzf-file-widget
    
    # Ctrl+R -> History search
    bindkey '^R' fzf-history-widget
    
    # Alt+C -> CD to directory
    bindkey '\ec' fzf-cd-widget
fi

# =====================================
# Vi Mode Enhancements
# =====================================

# Better searching in vi mode
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# Beginning/End of line in vi mode
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# Yank to system clipboard in vi mode (requires xclip)
if command -v xclip &> /dev/null; then
    vi-yank-clipboard() {
        zle vi-yank
        echo -n "$CUTBUFFER" | xclip -selection clipboard
    }
    zle -N vi-yank-clipboard
    bindkey -M vicmd 'y' vi-yank-clipboard
fi

# =====================================
# Custom Widget Functions
# =====================================

# Sudo the current/last command with Ctrl+S
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey '^s' sudo-command-line

# Open command in editor with Ctrl+X Ctrl+E (like bash)
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
bindkey -M vicmd v edit-command-line

# Quick directory jump with Alt+G
quick-cd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude ".git" . "${HOME}" 2> /dev/null | fzf +m) && cd "$dir"
    zle reset-prompt
}
zle -N quick-cd
bindkey '\eg' quick-cd

# Git status with Alt+S
git-status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git status
    else
        echo "Not a git repository"
    fi
    zle reset-prompt
}
zle -N git-status
bindkey '\es' git-status

# =====================================
# Directory Navigation
# =====================================

# Alt+Up -> Go to parent directory
cdUP() {
    cd ..
    zle reset-prompt
}
zle -N cdUP
bindkey '\e[1;3A' cdUP

# Alt+Down -> Go to previous directory
cdBACK() {
    cd -
    zle reset-prompt
}
zle -N cdBACK
bindkey '\e[1;3B' cdBACK

# =====================================
# Quick Actions
# =====================================

# Ctrl+G -> Git lazy
if command -v lazygit &> /dev/null; then
    lazygit-widget() {
        lazygit
        zle reset-prompt
    }
    zle -N lazygit-widget
    bindkey '^g' lazygit-widget
fi

# Ctrl+O -> Open file manager
if command -v yazi &> /dev/null; then
    yazi-widget() {
        yazi
        zle reset-prompt
    }
    zle -N yazi-widget
    bindkey '^o' yazi-widget
fi

# =====================================
# Copy/Paste with System Clipboard
# =====================================

if command -v xclip &> /dev/null; then
    # Ctrl+Shift+C -> Copy
    x-copy-region-as-kill() {
        zle copy-region-as-kill
        print -rn "$CUTBUFFER" | xclip -selection clipboard
    }
    zle -N x-copy-region-as-kill
    bindkey '^[[99;5u' x-copy-region-as-kill
    
    # Ctrl+Shift+V -> Paste
    x-paste() {
        CUTBUFFER=$(xclip -selection clipboard -o)
        zle yank
    }
    zle -N x-paste
    bindkey '^[[118;5u' x-paste
fi

# =====================================
# Help and Information
# =====================================

# F1 for help
bindkey '^[[11~' describe-key-briefly
bindkey '^[OP' describe-key-briefly

# =====================================
# Load local keybindings if they exist
# =====================================

if [ -f ~/.config/zsh/local-keybindings.zsh ]; then
    source ~/.config/zsh/local-keybindings.zsh
fi

# =====================================
# Show current keybindings help
# =====================================

show-keybindings() {
    cat <<-'EOF'
	
	Zsh Keybindings (macOS-inspired)
	=================================
	
	Navigation:
	  Ctrl+A / Alt+A    Beginning of line
	  Ctrl+E / Alt+E    End of line
	  Alt+Left/Right    Move word by word
	  Alt+Up            Parent directory
	  Alt+Down          Previous directory
	
	Editing:
	  Ctrl+W            Delete word backward
	  Ctrl+K            Kill to end of line
	  Ctrl+U            Kill to beginning of line
	  Ctrl+Z            Undo
	  Ctrl+Y            Redo
	
	History:
	  Ctrl+R            History search
	  Up/Down           History based on input
	
	Special:
	  Ctrl+S            Sudo last command
	  Ctrl+T            FZF file picker
	  Alt+C             FZF cd widget
	  Ctrl+G            LazyGit
	  Ctrl+O            Yazi file manager
	  Ctrl+X Ctrl+E     Edit command in editor
	  Alt+G             Quick directory jump
	  Alt+S             Git status
	
	EOF
    zle reset-prompt
}
zle -N show-keybindings
bindkey '^[h' show-keybindings