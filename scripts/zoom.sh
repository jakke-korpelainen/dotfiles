#!/bin/bash

# Define minimum and maximum zoom levels
MIN_ZOOM=0.5
MAX_ZOOM=3.0

# Get the current zoom factor
current_zoom=$(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}')

# Determine the operation (plus or minus)
operation="$1"

# Calculate the new zoom factor
if [ "$operation" = "+" ]; then
    new_zoom=$(awk "BEGIN {print $current_zoom + 0.5}")
elif [ "$operation" = "-" ]; then
    new_zoom=$(awk "BEGIN {print $current_zoom - 0.5}")
else
    exit 1
fi

# Set the new zoom factor
hyprctl keyword cursor:zoom_factor "$new_zoom"
