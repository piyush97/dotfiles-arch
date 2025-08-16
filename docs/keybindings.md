# ⌨️ Keybindings Reference

A comprehensive guide to all custom keybindings in this dotfiles configuration.

## 🐚 Zsh Shell Keybindings

### macOS-Inspired Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + A` / `Alt + A` | Beginning of line | Move cursor to start of line |
| `Ctrl + E` / `Alt + E` | End of line | Move cursor to end of line |
| `Alt + ←` / `Alt + →` | Word movement | Move cursor word by word |
| `Ctrl + W` | Delete word backward | Delete word before cursor |
| `Ctrl + K` | Kill to end | Delete from cursor to end of line |
| `Ctrl + U` | Kill to beginning | Delete from cursor to start of line |

### History and Search

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + R` | History search | FZF-powered history search |
| `↑` / `↓` | History navigation | Search history based on current input |
| `Ctrl + G` | Clear line | Clear current command line |

### Custom Functions

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + S` | Sudo command | Prepend/remove sudo from current command |
| `Alt + G` | Quick directory jump | FZF directory picker |
| `Alt + S` | Git status | Show git status if in repository |
| `Alt + ↑` | Parent directory | Navigate to parent directory |
| `Alt + ↓` | Previous directory | Return to previous directory |

### FZF Integration

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Ctrl + T` | File picker | Find and insert file path |
| `Alt + C` | Directory picker | Find and cd to directory |
| `Ctrl + R` | Command history | Search command history |

## 🖥️ Tmux Keybindings

### Session Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix` | `Ctrl + A` | Tmux prefix key |
| `Prefix + s` | Session list | Show and switch between sessions |
| `Prefix + $` | Rename session | Rename current session |
| `Prefix + d` | Detach | Detach from current session |

### Window Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + c` | New window | Create new window |
| `Prefix + ,` | Rename window | Rename current window |
| `Prefix + &` | Kill window | Close current window |
| `Prefix + n` | Next window | Switch to next window |
| `Prefix + p` | Previous window | Switch to previous window |
| `Prefix + 1-9` | Window by number | Switch to window by number |
| `Shift + ←/→` | Window navigation | Navigate windows (no prefix) |

### Pane Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + \|` | Vertical split | Split pane vertically |
| `Prefix + -` | Horizontal split | Split pane horizontally |
| `Prefix + x` | Kill pane | Close current pane |
| `Alt + ←/→/↑/↓` | Pane navigation | Navigate panes (no prefix) |
| `Prefix + H/J/K/L` | Resize panes | Resize panes vim-style |
| `Alt + Shift + ←/→/↑/↓` | Resize panes | Resize panes (no prefix) |

### Copy Mode

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Prefix + [` | Enter copy mode | Start copy mode |
| `v` | Start selection | Begin text selection |
| `y` | Copy selection | Copy and exit copy mode |
| `Escape` | Exit copy mode | Leave copy mode |

## 📝 Neovim Keybindings

### Basic Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Space` | Leader key | Main leader key |
| `jj` | Exit insert mode | Alternative to Escape |

### File Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>ff` | Find files | Telescope file finder |
| `<leader>fg` | Live grep | Search in files |
| `<leader>fb` | Buffers | Show open buffers |
| `<leader>fh` | Help tags | Search help |
| `<leader>e` | File explorer | Toggle Neo-tree |

### macOS-Like Shortcuts

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Alt + S` | Save file | Save current file |
| `Alt + A` | Select all | Select entire file |
| `Alt + C` | Copy | Copy selection to clipboard |
| `Alt + V` | Paste | Paste from clipboard |
| `Alt + Z` | Undo | Undo last change |
| `Alt + Shift + Z` | Redo | Redo last undone change |
| `Alt + F` | Find | Search in project |
| `Alt + P` | Command palette | File picker |
| `Alt + W` | Close buffer | Close current buffer |
| `Alt + /` | Toggle comment | Comment/uncomment lines |

### Git Integration

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit interface |
| `<leader>gc` | Git commits | Browse commits |
| `<leader>gs` | Git status | Show git status |
| `]h` | Next hunk | Go to next git hunk |
| `[h` | Previous hunk | Go to previous git hunk |

### LSP Functions

| Keybinding | Action | Description |
|------------|--------|-------------|
| `gd` | Go to definition | Jump to definition |
| `gr` | Go to references | Show references |
| `K` | Hover documentation | Show documentation |
| `<leader>ca` | Code actions | Show available actions |
| `<leader>rn` | Rename symbol | Rename under cursor |

## 🎮 Ghostty Terminal

### Tab Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Cmd + T` | New tab | Create new tab |
| `Cmd + W` | Close tab | Close current tab |
| `Cmd + Shift + [/]` | Tab navigation | Previous/Next tab |
| `Cmd + 1-9` | Tab by number | Jump to specific tab |

### Split Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Cmd + D` | Split right | Split terminal right |
| `Cmd + Shift + D` | Split down | Split terminal down |
| `Cmd + Alt + ←/→/↑/↓` | Navigate splits | Move between splits |

### Font and Display

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Cmd + +` | Increase font | Make text larger |
| `Cmd + -` | Decrease font | Make text smaller |
| `Cmd + 0` | Reset font | Reset to default size |
| `Cmd + Enter` | Toggle fullscreen | Enter/exit fullscreen |

### Utility

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Cmd + K` | Clear screen | Clear terminal output |
| `Cmd + R` | Reload config | Reload Ghostty configuration |
| `Cmd + F` | Find | Search in terminal output |

## 🔧 LazyGit Keybindings

### Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `j/k` | Move up/down | Navigate lists |
| `h/l` | Previous/Next panel | Switch between panels |
| `Tab` | Next panel | Cycle through panels |

### File Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `Space` | Stage/Unstage | Stage or unstage files |
| `a` | Stage all | Stage all changes |
| `c` | Commit | Create commit |
| `A` | Amend commit | Amend last commit |
| `d` | Discard changes | Discard file changes |

### Branch Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `n` | New branch | Create new branch |
| `o` | Checkout | Switch to branch |
| `d` | Delete branch | Delete selected branch |
| `M` | Merge | Merge branch into current |
| `r` | Rebase | Rebase current branch |

### Remote Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `P` | Push | Push to remote |
| `p` | Pull | Pull from remote |
| `f` | Fetch | Fetch from remote |

## 💡 Tips

### Discovering Keybindings

1. **Zsh**: Type `show-keybindings` (Alt + H) to see current bindings
2. **Tmux**: Press `Prefix + ?` to show all keybindings
3. **Neovim**: Use `<leader>sk` to search keymaps with Telescope
4. **LazyGit**: Press `?` to show help with all keybindings

### Customizing Keybindings

1. **Zsh**: Add custom bindings to `~/.config/zsh/local-keybindings.zsh`
2. **Tmux**: Modify `~/.config/tmux/tmux.conf`
3. **Neovim**: Create overrides in `~/.config/nvim/lua/config/keymaps.lua`
4. **Ghostty**: Edit `~/.config/ghostty/config`

### Muscle Memory Tips

1. Start with the most frequently used shortcuts
2. Practice one category at a time (e.g., navigation first)
3. Use the built-in help systems when you forget
4. Gradually adopt more advanced shortcuts as you become comfortable

---

**💡 Pro Tip**: These keybindings are designed to be consistent across applications, making them easier to remember!