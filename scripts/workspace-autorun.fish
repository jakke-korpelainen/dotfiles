#!/usr/bin/fish

# Function to display usage information
function display_usage
    echo "Usage: $argv[1] <workspace_number>"
    echo "Example: 2 $argv[1]"
end

# Check if the workspace number is provided
if test (count $argv) -ne 1
    display_usage
    exit 1
end

set WORKSPACE_NUMBER $argv[1]

# Function to check if an application is running in a specific workspace
function autorun_app_in_workspace
    set workspace_id $argv[1]
    set app_name $argv[2]

    # Get the JSON output from hyprctl clients
    set json_output (hyprctl clients -j)

    # Use jq to parse the JSON and check if the app is running in the workspace
    set result (echo $json_output | jq --arg workspace_id "$workspace_id" --arg app_name "$app_name" '
        .[] | select(.workspace.id == ($workspace_id | tonumber) and .class == $app_name)')

    # launch app if not running
    if test -z "$result"
        exec $app_name &
    end
end

# Autorun applications for specific workspaces
switch $WORKSPACE_NUMBER
    case 2
        autorun_app_in_workspace $WORKSPACE_NUMBER firefox
    case 3
        autorun_app_in_workspace $WORKSPACE_NUMBER discord
    case '*'
        # No specific autorun apps for other workspaces
end
