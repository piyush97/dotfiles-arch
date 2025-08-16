# 🎨 How to Apply KDE Tokyo Night Theme

Follow these steps to safely apply the beautiful Tokyo Night theme to your KDE Plasma desktop.

## 📋 Step-by-Step Instructions

### 1️⃣ **Create Backup of Current Configuration**

First, let's safely backup your current KDE settings:

```bash
# Navigate to the dotfiles repository
cd /home/piyush/claude-sandbox/modern-dotfiles

# Run the backup script
bash backup-kde-config.sh
```

This will:
- ✅ Create a timestamped backup of all KDE settings
- ✅ Generate a restoration script if you want to revert
- ✅ Preserve your current desktop configuration

### 2️⃣ **Apply Tokyo Night Theme**

Now apply the new configuration:

```bash
# Install KDE package using Stow
bash install-stow.sh kde
```

This will:
- 🎨 Install Tokyo Night color scheme
- ⌨️ Set up macOS-inspired keyboard shortcuts
- 🪟 Configure modern window management
- 🎛️ Create dock-style panel layout

### 3️⃣ **Restart KDE Components**

Apply the changes by restarting Plasma:

```bash
# Stop Plasma shell
kquitapp6 plasmashell

# Wait a moment
sleep 2

# Start Plasma shell with new configuration
plasmashell &
```

### 4️⃣ **Apply Color Scheme**

Set the Tokyo Night color scheme:

```bash
# Apply the custom color scheme
kreadconfig6 --file kdeglobals --group General --key ColorScheme
kwriteconfig6 --file kdeglobals --group General --key ColorScheme "Tokyo Night"

# Restart KDE to apply color changes
qdbus org.kde.KWin /KWin reconfigure
```

### 5️⃣ **Final Restart (Recommended)**

For best results, logout and login again:

```bash
# Option 1: Logout through GUI
# System Settings → Leave → Log Out

# Option 2: Command line logout
qdbus org.kde.ksmserver /KSMServer logout 0 0 0
```

## 🎯 What You'll Get

After applying these changes, you'll have:

### 🎨 **Visual Improvements**
- **Tokyo Night color scheme** everywhere
- **Dark theme** with blue/purple accents
- **Modern window decorations**
- **Consistent theming** with terminal and editor

### ⌨️ **macOS-Style Shortcuts**
- **Meta+Space** → Application launcher (like Cmd+Space)
- **Meta+Tab** → Window switcher (like Cmd+Tab)
- **Meta+D** → Show desktop (like F11)
- **Meta+L** → Lock screen (like Cmd+Ctrl+Q)
- **Meta+E** → File manager (like Cmd+Space → Finder)
- **Meta+T** → Terminal (like Cmd+Space → Terminal)

### 🪟 **Window Management**
- **Meta+Left/Right** → Tile windows
- **Meta+Up** → Maximize window
- **Meta+Down** → Minimize/restore window
- **Meta+W** → Close window (like Cmd+W)

### 🎛️ **Modern Panel**
- **Bottom dock** with icon-only apps
- **Global menu** at the top
- **Clean system tray**
- **Digital clock**

## 🚨 Troubleshooting

### If something goes wrong:

#### **Restore Original Settings**
```bash
# Navigate to your backup folder (check the backup script output for exact path)
cd ~/.kde-backup-YYYYMMDD_HHMMSS

# Run the restore script
bash restore-kde-config.sh
```

#### **Reset to Defaults**
```bash
# Reset Plasma to defaults
rm ~/.config/plasma*
rm ~/.config/kdeglobals
rm ~/.config/kwinrc

# Logout and login again
```

#### **Manually Apply Color Scheme**
If colors don't apply automatically:

1. Open **System Settings**
2. Go to **Appearance** → **Colors**
3. Select **Tokyo Night** from the list
4. Click **Apply**

## 🎉 Enjoy Your New Desktop!

Once applied, you'll have a beautiful, cohesive desktop experience that matches your terminal and development environment perfectly!

### 📸 **Features to Try**
- Press **Meta+Space** to launch apps
- Try **Meta+Tab** to switch between windows
- Use **Meta+Left/Right** to tile windows
- Check out the new Tokyo Night colors everywhere
- Enjoy the smooth animations and modern effects

---

**Need help?** Check the backup folder for restoration options or create an issue in the repository.