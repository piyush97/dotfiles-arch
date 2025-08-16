#!/usr/bin/env zsh
# Enhanced aliases for productivity

# =====================================
# macOS-like aliases
# =====================================

# Quick Look (preview files)
if [[ -x "$(command -v bat)" ]]; then
    # alias ql='bat --style=numbers --color=always'  # Commented out to avoid conflict with ql() function
    alias quicklook='bat --style=numbers --color=always'
fi

# Trash instead of rm (safer)
if [[ -x "$(command -v trash)" ]]; then
    alias rm='trash'
    alias del='trash'
elif [[ -x "$(command -v gio)" ]]; then
    alias rm='gio trash'
    alias del='gio trash'
fi

# =====================================
# Navigation aliases
# =====================================

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Quick directory jumps
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias docs='cd ~/Documents'
alias proj='cd ~/Projects'
alias dotfiles='cd ~/dotfiles'
alias config='cd ~/.config'

# =====================================
# Enhanced ls aliases with lsd
# =====================================

if [[ -x "$(command -v lsd)" ]]; then
    alias ls='lsd -F --group-dirs first'
    alias l='lsd -F --group-dirs first'
    alias ll='lsd -lahF --group-dirs first'
    alias la='lsd -A --group-dirs first'
    alias lt='lsd --tree --depth=2 --group-dirs first'
    alias lta='lsd --tree --depth=2 -A --group-dirs first'
    alias ltd='lsd --tree --depth=3 --group-dirs first'
    alias ltda='lsd --tree --depth=3 -A --group-dirs first'
else
    alias l='ls -lFh'
    alias la='ls -lAFh'
    alias lr='ls -tRFh'
    alias lt='ls -ltFh'
    alias ll='ls -l'
fi

# =====================================
# Git enhancements
# =====================================

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v --amend'
alias gcane='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias gm='git merge'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gr='git remote'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grs='git reset'
alias grsh='git reset --hard'
alias gst='git status'
alias gsta='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Lazygit shortcut
if [[ -x "$(command -v lazygit)" ]]; then
    alias lg='lazygit'
fi

# =====================================
# Docker aliases
# =====================================

if [[ -x "$(command -v docker)" ]]; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dimg='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dexec='docker exec -it'
    alias dlogs='docker logs -f'
    alias dprune='docker system prune -a'
    
    # Docker compose shortcuts
    alias dcup='docker-compose up'
    alias dcupd='docker-compose up -d'
    alias dcdown='docker-compose down'
    alias dclogs='docker-compose logs -f'
    alias dcbuild='docker-compose build'
fi

# =====================================
# Development aliases
# =====================================

# Node.js/npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'

# pnpm
if [[ -x "$(command -v pnpm)" ]]; then
    alias pn='pnpm'
    alias pni='pnpm install'
    alias pnr='pnpm run'
    alias pnx='pnpm dlx'
fi

# yarn
if [[ -x "$(command -v yarn)" ]]; then
    alias y='yarn'
    alias ya='yarn add'
    alias yad='yarn add --dev'
    alias yr='yarn run'
    alias yrm='yarn remove'
fi

# Python
alias py='python3'
alias pip='pip3'
alias pyvenv='python3 -m venv'
alias pyactivate='source venv/bin/activate'

# Go
alias gor='go run'
alias gob='go build'
alias got='go test'
alias gom='go mod'
alias gomt='go mod tidy'
alias gomv='go mod vendor'

# =====================================
# System management
# =====================================

# Arch/Pacman
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacss='pacman -Ss'
alias pacsi='pacman -Si'
alias pacr='sudo pacman -R'
alias pacrs='sudo pacman -Rs'
alias pacu='sudo pacman -Syu'
alias pacq='pacman -Q'
alias pacqi='pacman -Qi'

# Yay (AUR helper)
if [[ -x "$(command -v yay)" ]]; then
    alias yays='yay -S'
    alias yayss='yay -Ss'
    alias yayr='yay -R'
    alias yayrs='yay -Rs'
    alias yayu='yay -Syu'
fi

# System
alias sysupdate='sudo pacman -Syu && yay -Syu'
alias sysmem='free -h'
alias syscpu='lscpu'
alias sysdisk='df -h'
alias sysports='sudo netstat -tulanp'
alias sysservices='systemctl list-units --type=service'

# =====================================
# Network aliases
# =====================================

alias myip='curl -s ifconfig.me && echo'
alias localip='ip -br -c a'
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias speed='speedtest-cli'

# =====================================
# Utility aliases
# =====================================

# Clipboard
if [[ -x "$(command -v xclip)" ]]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
elif [[ -x "$(command -v xsel)" ]]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

# Archive extraction
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz='tar -xjvf'

# File operations
alias cpv='rsync -ah --info=progress2'
alias search='rg --hidden --follow'
alias find='fd --hidden --follow'

# Process management
alias psg='ps aux | grep -v grep | grep -i'
alias killport='function _killport(){ lsof -ti :$1 | xargs kill -9; }; _killport'

# =====================================
# Tmux aliases
# =====================================

if [[ -x "$(command -v tmux)" ]]; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tad='tmux attach -d -t'
    alias ts='tmux new-session -s'
    alias tl='tmux list-sessions'
    alias tk='tmux kill-session -t'
    alias tka='tmux kill-server'
    alias txr='tmux source-file ~/.tmux.conf'
fi

# =====================================
# Editor aliases
# =====================================

if [[ -x "$(command -v nvim)" ]]; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias nv='nvim'
    alias svi='sudo nvim'
    alias svim='sudo nvim'
fi

# VS Code
if [[ -x "$(command -v code)" ]]; then
    alias c.='code .'
    alias ca='code --add'
    alias cd='code --diff'
fi

if [[ -x "$(command -v code-insiders)" ]]; then
    alias ci='code-insiders'
    alias ci.='code-insiders .'
fi

# =====================================
# Miscellaneous
# =====================================

# Weather
alias weather='curl wttr.in'
alias weatherfull='curl "wttr.in?format=v2"'

# Calendar
alias cal='cal -3'

# Disk usage
alias du='du -h'
alias duf='du -sh *'

# History
alias h='history'
alias hgrep='history | grep'

# Clear
alias cls='clear'
alias cl='clear'

# Exit
alias quit='exit'
alias bye='exit'

# Reload shell
alias reload='exec $SHELL -l'
alias zshrc='${=EDITOR} ~/.zshrc && source ~/.zshrc'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# =====================================
# Modern Command Replacements
# =====================================

# Replace cat with bat (better syntax highlighting)
if [[ -x "$(command -v bat)" ]]; then
    alias cat='bat --paging=never'
    alias less='bat'
    alias more='bat'
fi

# Replace find with fd (faster and more user-friendly)
if [[ -x "$(command -v fd)" ]]; then
    alias find='fd'
fi

# Replace grep with ripgrep (faster search)
if [[ -x "$(command -v rg)" ]]; then
    alias grep='rg --color=auto'
fi

# Replace du with dust (better disk usage visualization)
if [[ -x "$(command -v dust)" ]]; then
    alias du='dust'
fi

# Replace df with duf (better disk free display)
if [[ -x "$(command -v duf)" ]]; then
    alias df='duf'
fi

# Replace ps with procs (better process viewer)
if [[ -x "$(command -v procs)" ]]; then
    alias ps='procs'
fi

# Replace top/htop with btop (better system monitor)
if [[ -x "$(command -v btop)" ]]; then
    alias top='btop'
    alias htop='btop'
fi

# Replace ping with prettyping (if available)
if [[ -x "$(command -v prettyping)" ]]; then
    alias ping='prettyping --nolegend'
fi

# Replace diff with delta (better diffs)
if [[ -x "$(command -v delta)" ]]; then
    alias diff='delta'
fi

# Replace ncdu with gdu (if available)
if [[ -x "$(command -v gdu)" ]]; then
    alias ncdu='gdu'
fi

# Replace dig with dog (if available)
if [[ -x "$(command -v dog)" ]]; then
    alias dig='dog'
fi

# Replace curl with httpie for API testing
if [[ -x "$(command -v http)" ]]; then
    alias curl='echo "💡 Tip: Use http/https commands for API testing, or use \\curl for raw curl"; http'
fi

# =====================================
# Suffix aliases (auto open with program)
# =====================================

alias -s {md,markdown}=bat
alias -s {json,yml,yaml,toml}=bat
alias -s {jpg,jpeg,png,gif,bmp}=xdg-open
alias -s {pdf,PDF}=xdg-open
alias -s {mp4,avi,mkv,mov}=xdg-open
alias -s {zip,tar,gz,bz2,xz}=unarchive