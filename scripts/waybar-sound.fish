#!/usr/bin/fish

# Function to display usage information
function display_usage
    echo "Usage: ./ <volume_action>"
    echo "Example: ./ \"raise\""
end

# Volume level icons§
set vol_high 
set vol_mute 

# Check if the workspace number is provided
if test (count $argv) -ne 1
    display_usage
    exit 1
end

# Function to change the volume and send a notification
function change_volume -a direction
    # Play the volume change sound
    paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

    if test "$direction" = "raise"
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    else if test "$direction" = "lower"
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
    end

    set volume (string trim (wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'))
    notify-send "$vol_high" "$volume"
end

function toggle_mute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    set muted (wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')

    if test "$muted" = "[MUTED]"
        # Send notification with the updated volume and icon
        notify-send "$vol_mute" "Muted"
    else
        # Send notification with the updated volume and icon
        notify-send "$vol_high" "Unmuted"
    end
end

set sound_operation $argv[1]

if test "$sound_operation" = "raise" || test "$sound_operation" = "lower"
    change_volume "$sound_operation"
else if test "$sound_operation" = "mute"
    toggle_mute
end
