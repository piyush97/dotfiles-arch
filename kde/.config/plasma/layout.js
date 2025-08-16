// Tokyo Night themed Plasma layout with macOS-inspired dock
// This script configures the panel layout for a modern, clean desktop experience

var plasma = getApiVersion(1);

// Remove existing panels
for (i = 0; i < panelIds.length; ++i) {
    panelById(panelIds[i]).remove()
}

// Create main bottom panel (dock-style)
var panel = new Panel
panel.location = "bottom"
panel.height = 58
panel.lengthMode = "fit"
panel.hiding = "none"
panel.alignment = "center"

// Configure panel appearance
panel.panelVisibility = "normalpanel"

// Add widgets to the panel
var kickoff = panel.addWidget("org.kde.plasma.kickoff")
kickoff.currentConfigGroup = ["Shortcuts"]
kickoff.writeConfig("global", "Alt+F1")

// Add task manager with icon-only mode for dock appearance
var taskManager = panel.addWidget("org.kde.plasma.icontasks")
taskManager.currentConfigGroup = ["General"]
taskManager.writeConfig("launchers", ["applications:systemsettings.desktop", "applications:org.kde.dolphin.desktop", "applications:org.kde.konsole.desktop", "applications:firefox.desktop", "applications:code-insiders.desktop"])
taskManager.writeConfig("showOnlyCurrentDesktop", false)
taskManager.writeConfig("showOnlyCurrentActivity", true)
taskManager.writeConfig("groupingStrategy", 0)
taskManager.writeConfig("onlyGroupWhenFull", true)
taskManager.writeConfig("forceStretchTasks", true)

// Add system tray
var systemTray = panel.addWidget("org.kde.plasma.systemtray")

// Add digital clock
var clock = panel.addWidget("org.kde.plasma.digitalclock")
clock.currentConfigGroup = ["Appearance"]
clock.writeConfig("showDate", false)
clock.writeConfig("use24hFormat", 2)

// Create top panel for global menu and window title
var topPanel = new Panel
topPanel.location = "top"
topPanel.height = 30
topPanel.lengthMode = "fit"
topPanel.hiding = "none"

// Add global menu
var globalMenu = topPanel.addWidget("org.kde.plasma.appmenu")

// Add window title
var windowTitle = topPanel.addWidget("org.kde.plasma.windowtitle")

// Add spacer
topPanel.addWidget("org.kde.plasma.panelspacer")

// Add user switcher
var userSwitcher = topPanel.addWidget("org.kde.plasma.userswitcher")

// Desktop configuration
var desktopsArray = desktopsForActivity(currentActivity());
for (var j = 0; j < desktopsArray.length; j++) {
    var desktop = desktopsArray[j];
    
    // Set wallpaper
    desktop.wallpaperPlugin = "org.kde.image";
    desktop.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
    desktop.writeConfig("Image", "/usr/share/wallpapers/Next/contents/images/5120x2880.png");
    desktop.writeConfig("FillMode", 6); // Scaled and cropped
}