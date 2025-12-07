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

# Switch to the specified workspace
hyprctl dispatch workspace $WORKSPACE_NUMBER

# Call the autorun script with the workspace number
fish ~/.config/scripts/workspace-autorun.fish $WORKSPACE_NUMBER
