#!/usr/bin/fish

# Function to display usage information
function display_usage
    echo "Usage: $argv[0] <workspace_number>"
    echo "Example: $argv[0] 2"
end

# Check if the workspace number is provided
if test (count $argv) -ne 1
    display_usage
    exit 1
end

set WORKSPACE_NUMBER $argv[1]
set MONITOR "HDMI-A-1"
set RESOLUTION "3840x2160@60"

# Switch to the specified workspace
hyprctl dispatch workspace $WORKSPACE_NUMBER

# Set gaming scaling for /games workspace
if test $WORKSPACE_NUMBER -eq 4
    hyprctl keyword monitor "$MONITOR", $RESOLUTION,0x0,1
else
    hyprctl keyword monitor "$MONITOR", $RESOLUTION,0x0,2
end

# Call the autorun script with the workspace number
fish ~/.config/scripts/workspace-autorun.fish $WORKSPACE_NUMBER
