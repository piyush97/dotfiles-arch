#!/bin/bash

# KDE Configuration Backup Script
# Creates a backup of current KDE settings before applying new configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Icons
SUCCESS="✅"
ERROR="❌"
INFO="ℹ️"
BACKUP="💾"

# Variables
BACKUP_DIR="$HOME/.kde-backup-$(date +%Y%m%d_%H%M%S)"

# Function to print colored output
print_success() { echo -e "${GREEN}${SUCCESS} $1${NC}"; }
print_error() { echo -e "${RED}${ERROR} $1${NC}"; }
print_info() { echo -e "${CYAN}${INFO} $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_backup() { echo -e "${BLUE}${BACKUP} $1${NC}"; }

echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           💾 KDE Configuration Backup Tool                  ║
║                                                              ║
║     • Safely backup current KDE Plasma settings             ║
║     • Preserve your existing desktop configuration          ║
║     • Easy restoration if needed                            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

print_info "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# KDE configuration files to backup
KDE_CONFIGS=(
    "kdeglobals"
    "kwinrc"
    "plasmarc"
    "kglobalshortcutsrc"
    "plasmashellrc"
    "plasma-localerc"
    "plasmanotifyrc"
    "kwinoutputconfig.json"
    "kded5rc"
    "kded6rc"
    "filetypesrc"
    "dolphinrc"
    "baloofilerc"
    "bluedevilglobalrc"
    "discoverrc"
)

# Backup individual config files
print_info "Backing up KDE configuration files..."
for config in "${KDE_CONFIGS[@]}"; do
    if [ -f "$HOME/.config/$config" ]; then
        cp "$HOME/.config/$config" "$BACKUP_DIR/" 2>/dev/null && \
        print_backup "Backed up: $config" || \
        print_warning "Could not backup: $config"
    fi
done

# Backup directories
print_info "Backing up KDE configuration directories..."

# Plasma configuration
if [ -d "$HOME/.config/plasma" ]; then
    cp -r "$HOME/.config/plasma" "$BACKUP_DIR/" 2>/dev/null && \
    print_backup "Backed up: plasma directory"
fi

# KDE defaults
if [ -d "$HOME/.config/kdedefaults" ]; then
    cp -r "$HOME/.config/kdedefaults" "$BACKUP_DIR/" 2>/dev/null && \
    print_backup "Backed up: kdedefaults directory"
fi

# Color schemes
if [ -d "$HOME/.local/share/color-schemes" ]; then
    mkdir -p "$BACKUP_DIR/.local/share"
    cp -r "$HOME/.local/share/color-schemes" "$BACKUP_DIR/.local/share/" 2>/dev/null && \
    print_backup "Backed up: color-schemes directory"
fi

# Plasma themes
if [ -d "$HOME/.local/share/plasma" ]; then
    cp -r "$HOME/.local/share/plasma" "$BACKUP_DIR/.local/share/" 2>/dev/null && \
    print_backup "Backed up: plasma themes directory"
fi

# Create restoration script
cat > "$BACKUP_DIR/restore-kde-config.sh" << 'RESTORE_EOF'
#!/bin/bash

# KDE Configuration Restoration Script
# Restores KDE settings from this backup

set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Restoring KDE configuration from backup..."
echo "Backup location: $BACKUP_DIR"

# Stop Plasma to apply changes safely
echo "Stopping Plasma shell..."
kquitapp6 plasmashell 2>/dev/null || true
sleep 2

# Restore configuration files
for file in "$BACKUP_DIR"/*.{rc,json,conf}; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    cp "$file" "$HOME/.config/" && \
    echo "✅ Restored: $filename"
done

# Restore directories
if [ -d "$BACKUP_DIR/plasma" ]; then
    rm -rf "$HOME/.config/plasma" 2>/dev/null || true
    cp -r "$BACKUP_DIR/plasma" "$HOME/.config/" && \
    echo "✅ Restored: plasma directory"
fi

if [ -d "$BACKUP_DIR/kdedefaults" ]; then
    rm -rf "$HOME/.config/kdedefaults" 2>/dev/null || true
    cp -r "$BACKUP_DIR/kdedefaults" "$HOME/.config/" && \
    echo "✅ Restored: kdedefaults directory"
fi

if [ -d "$BACKUP_DIR/.local/share/color-schemes" ]; then
    mkdir -p "$HOME/.local/share"
    rm -rf "$HOME/.local/share/color-schemes" 2>/dev/null || true
    cp -r "$BACKUP_DIR/.local/share/color-schemes" "$HOME/.local/share/" && \
    echo "✅ Restored: color-schemes directory"
fi

if [ -d "$BACKUP_DIR/.local/share/plasma" ]; then
    rm -rf "$HOME/.local/share/plasma" 2>/dev/null || true
    cp -r "$BACKUP_DIR/.local/share/plasma" "$HOME/.local/share/" && \
    echo "✅ Restored: plasma themes directory"
fi

# Restart Plasma
echo "Restarting Plasma shell..."
plasmashell &
sleep 3

echo "🎉 KDE configuration restored successfully!"
echo "You may need to logout and login again for all changes to take effect."
RESTORE_EOF

chmod +x "$BACKUP_DIR/restore-kde-config.sh"

# Create backup info file
cat > "$BACKUP_DIR/BACKUP_INFO.txt" << EOF
KDE Configuration Backup
========================

Backup Date: $(date)
Backup Location: $BACKUP_DIR
System: $(uname -a)
KDE Version: $(plasmashell --version 2>/dev/null || echo "Unknown")
User: $USER

Files Backed Up:
$(ls -la "$BACKUP_DIR" | grep -v "^total" | awk '{print "  " $9 " (" $5 " bytes)"}')

To Restore:
-----------
Run: bash $BACKUP_DIR/restore-kde-config.sh

Or manually copy files from this backup directory to ~/.config/

Original dotfiles repository: ~/.dotfiles
EOF

print_success "Backup completed successfully!"
print_info "Backup location: $BACKUP_DIR"
print_info "To restore later, run: bash $BACKUP_DIR/restore-kde-config.sh"

echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Your current KDE configuration is safely backed up"
echo "2. Now you can apply the Tokyo Night theme:"
echo "   cd ~/.dotfiles && bash install-stow.sh kde"
echo "3. Logout and login to see all changes"
echo "4. If you want to revert, use the restore script in the backup folder"