#!/usr/bin/env zsh
# Enhanced Zsh functions for productivity

# =====================================
# File and Directory Operations
# =====================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$@" && cd "$@"
}

# Create a temporary directory and cd into it
mktmp() {
    cd $(mktemp -d)
    pwd
}

# Go up N directories (up 3 = cd ../../..)
up() {
    local count=${1:-1}
    local path=""
    for i in $(seq 1 $count); do
        path="../$path"
    done
    cd $path
}

# Archive extraction with auto-detection
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *.deb)       ar x $1        ;;
            *.tar.xz)    tar xf $1      ;;
            *.tar.zst)   unzstd $1      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create archive
archive() {
    local name=$1
    shift
    case $name in
        *.tar.gz)  tar czf $name $@ ;;
        *.tar.bz2) tar cjf $name $@ ;;
        *.tar.xz)  tar cJf $name $@ ;;
        *.zip)     zip -r $name $@ ;;
        *.7z)      7z a $name $@ ;;
        *)         echo "Unknown archive format" ;;
    esac
}

# Backup file with timestamp
backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File not found: $1"
    fi
}

# =====================================
# Navigation Functions
# =====================================

# Fuzzy find and cd to directory
fcd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude ".git" . "${1:-.}" 2> /dev/null | fzf +m) && cd "$dir"
}

# Fuzzy find and open file in editor
fe() {
    local files
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

# Fuzzy find in history
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Kill process with fzf
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Git branch switch with fzf
fbr() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Git commit browser with fzf
fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

# =====================================
# Development Functions
# =====================================

# Run command in all git repos under current directory
git_all() {
    find . -type d -name ".git" | while read git_dir; do
        dir=$(dirname "$git_dir")
        echo "📁 Processing $dir"
        (cd "$dir" && eval "$@")
        echo ""
    done
}

# Quick git commit with message
gcq() {
    git add -A && git commit -m "$*"
}

# Create a new project directory with git
project() {
    local name=$1
    local type=${2:-general}
    
    mkdir -p ~/Projects/$name
    cd ~/Projects/$name
    
    git init
    
    case $type in
        node)
            npm init -y
            echo "node_modules/" > .gitignore
            echo "# $name" > README.md
            ;;
        python)
            python3 -m venv venv
            echo "venv/" > .gitignore
            echo "__pycache__/" >> .gitignore
            echo "*.pyc" >> .gitignore
            echo "# $name" > README.md
            touch requirements.txt
            ;;
        go)
            go mod init $name
            echo "# $name" > README.md
            ;;
        *)
            echo "# $name" > README.md
            ;;
    esac
    
    git add -A
    git commit -m "Initial commit"
    
    echo "✅ Project created at ~/Projects/$name"
}

# Docker cleanup
docker_cleanup() {
    docker container prune -f
    docker image prune -f
    docker network prune -f
    docker volume prune -f
}

# =====================================
# System Functions
# =====================================

# System information
sysinfo() {
    echo "System Information"
    echo "=================="
    echo "Hostname:     $(hostname)"
    echo "OS:          $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "Kernel:      $(uname -r)"
    echo "Uptime:      $(uptime -p)"
    echo "CPU:         $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo "Memory:      $(free -h | awk '/^Mem:/ {print $3 " / " $2}')"
    echo "Disk:        $(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 " used)"}')"
    echo "IP:          $(ip -4 -br a | grep UP | awk '{print $3}' | cut -d'/' -f1 | head -1)"
}

# Check port usage
port() {
    if [ -z "$1" ]; then
        echo "Usage: port <port_number>"
        return 1
    fi
    sudo lsof -i :$1
}

# =====================================
# Network Functions
# =====================================

# Test network speed
speedtest() {
    if command -v speedtest-cli &> /dev/null; then
        speedtest-cli
    else
        echo "Installing speedtest-cli..."
        pip install --user speedtest-cli
        speedtest-cli
    fi
}

# Get public IP with location info
myip_full() {
    curl -s ipinfo.io | jq .
}

# =====================================
# Utility Functions
# =====================================

# Calculator
calc() {
    echo "$*" | bc -l
}

# Color palette
colors() {
    for i in {0..255}; do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
    done
}

# Man pages in color
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# Weather for a location
wttr() {
    local location="${1:-}"
    curl -H "Accept-Language: ${LANG%_*}" "wttr.in/${location}?format=v2"
}

# Quick note taking
note() {
    local note_dir="$HOME/Documents/notes"
    mkdir -p "$note_dir"
    
    if [ $# -eq 0 ]; then
        # List notes
        ls -1 "$note_dir"
    elif [ "$1" = "edit" ]; then
        # Edit note
        ${EDITOR:-nvim} "$note_dir/$2.md"
    elif [ "$1" = "show" ]; then
        # Show note
        bat "$note_dir/$2.md" 2>/dev/null || cat "$note_dir/$2.md"
    else
        # Quick note
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >> "$note_dir/quick.md"
        echo "Note saved to quick.md"
    fi
}

# =====================================
# macOS-like Functions
# =====================================

# Open file or URL (like macOS open command)
if ! command -v open &> /dev/null; then
    open() {
        xdg-open "$@" 2>/dev/null &
    }
fi

# Quick Look (preview file)
ql() {
    if [ -f "$1" ]; then
        case "$1" in
            *.pdf) evince "$1" 2>/dev/null & ;;
            *.jpg|*.jpeg|*.png|*.gif) feh "$1" 2>/dev/null & ;;
            *.mp4|*.avi|*.mkv) mpv "$1" 2>/dev/null & ;;
            *) bat --style=full --color=always "$1" | less -R ;;
        esac
    else
        echo "File not found: $1"
    fi
}

# Trash (move to trash instead of delete)
trash() {
    local trash_dir="$HOME/.local/share/Trash/files"
    mkdir -p "$trash_dir"
    for item in "$@"; do
        mv "$item" "$trash_dir/"
        echo "Moved to trash: $item"
    done
}

# Empty trash
empty_trash() {
    local trash_dir="$HOME/.local/share/Trash/files"
    if [ -d "$trash_dir" ]; then
        rm -rf "$trash_dir"/*
        echo "Trash emptied"
    else
        echo "Trash is already empty"
    fi
}

# =====================================
# Tmux Functions
# =====================================

# Tmux session manager
tm() {
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    if [ $1 ]; then
        tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
    fi
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux $change -t "$session" || echo "No sessions found."
}

# Create tmux session for current directory
tms() {
    local session_name=$(basename "$PWD" | tr . _)
    tmux new-session -d -s "$session_name" 2>/dev/null
    tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
}

# =====================================
# Git Functions
# =====================================

# Git log with graph
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
}

# Git status for all repos in current directory
gstatus_all() {
    for dir in */; do
        if [ -d "$dir/.git" ]; then
            echo "📁 $dir"
            (cd "$dir" && git status -s)
            echo ""
        fi
    done
}

# =====================================
# Load local functions if they exist
# =====================================

if [ -f ~/.config/zsh/local-functions.zsh ]; then
    source ~/.config/zsh/local-functions.zsh
fi