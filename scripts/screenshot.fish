#!/usr/bin/fish

# Function to display usage information
function display_usage
    echo "Usage: $argv[0] <screenshot_method>"
    echo "Example: $argv[0] 'fullscreen'"
end

# Check if the workspace number is provided
if test (count $argv) -ne 1
    display_usage
    exit 1
end

set screenshot_method $argv[1]

if test $screenshot_method = "fullscreen"
    grim - | wl-copy
    notify-send "Fullscreen screenshot copied to clipboard"
    exit 0
end

if test $screenshot_method = "region"
    grim -g "$(slurp)" - | wl-copy
    notify-send "Region screenshot copied to clipboard"
    exit 0
end

display_usage
exit 1
