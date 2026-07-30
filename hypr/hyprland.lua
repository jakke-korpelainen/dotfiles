-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

-- Simple zoom functions that work reliably
local function zoom_in()
    hl.config({ cursor = { zoom_factor = 1.5 } })
end

local function zoom_out()
    hl.config({ cursor = { zoom_factor = 0.75 } })
end

local function zoom_reset()
    hl.config({ cursor = { zoom_factor = 1.0 } })
end


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "3840x2160@60",
    position = "0x0",
    scale    = 2,
    bitdepth = 10,
    cm       = "hdr",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "nemo"
local menu        = "wofi --show drun --allow-images"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function ()
  hl.exec_cmd("protonvpn connect &")
  hl.exec_cmd("waybar & hypridle &")
  hl.exec_cmd(terminal)
  hl.exec_cmd("discord --start-minimized")
  hl.exec_cmd("dbus-launch --sh-syntax > ~/.dbus-env && . ~/.dbus-env && /usr/bin/gnome-keyring-daemon --start --components=secrets,ssh")
  hl.exec_cmd("hyprshell run &")
  hl.dsp.focus({ workspace = 1 })
end)

-- Native Lua workspace autorun system
local function autorun_app_if_not_running(app_name)
    -- Simple function: launch app if it's not running anywhere
    -- Window rules will handle moving it to the correct workspace

    -- Use a temporary file to capture the output from hyprctl
    hl.exec_cmd("hyprctl clients -j > /tmp/hypr_clients.json")
    local clients_file = io.open("/tmp/hypr_clients.json", "r")
    local clients = ""
    if clients_file then
        clients = clients_file:read("*a")
        clients_file:close()
    end

    -- Check if app is running anywhere
    local app_running = false
    if clients ~= "" and clients ~= nil then
        if string.find(clients, '"class":%s*"' .. app_name .. '"') then
            app_running = true
        end
    end

    -- Launch app if not running
    if not app_running then
        hl.exec_cmd(app_name .. " &")
    end
end

-- Workspace change event handler with native Lua autorun
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/
hl.on("workspace.active", function (workspace)
    local workspace_id = workspace.id

    -- Autorun applications for specific workspaces
    -- Window rules will handle moving apps to correct workspaces
    if workspace_id == 2 then
        autorun_app_if_not_running("firefox")
    elseif workspace_id == 3 then
        autorun_app_if_not_running("discord")
    elseif workspace_id == 4 then
        autorun_app_if_not_running("steam")
    end
    -- Other workspaces have no specific autorun apps
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 10,
        gaps_out = 10,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgb(bb9af7)", "rgb(bb9af7)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "fi",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

----------------------
---- KEYBINDINGS ----
----------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("fish ~/.config/scripts/screenshot.fish \"fullscreen\""))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("fish ~/.config/scripts/screenshot.fish \"region\""))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("fish ~/.config/scripts/screenshot.fish \"region\""))

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Zoom using simple functions
hl.bind(mainMod .. " + plus", zoom_in)
hl.bind(mainMod .. " + minus", zoom_out)
hl.bind(mainMod .. " + 0", zoom_reset)

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, function()
        -- Switch to the workspace using the correct Hyprland API
        hl.dsp.focus({ workspace = i })
    end)
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Cycle through workspaces with mainMod + Tab
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }) )
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Custom mute
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("fish ~/.config/scripts/waybar-sound.fish \"mute\""))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("fish ~/.config/scripts/waybar-sound.fish \"raise\""), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("fish ~/.config/scripts/waybar-sound.fish \"lower\""), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("fish ~/.config/scripts/waybar-sound.fish \"deafen\""), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("fish ~/.config/scripts/waybar-sound.fish \"mute\""), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---------------------------------
---- WINDOWS AND WORKSPACES ----
---------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Keep Kitty in workspace 1
hl.window_rule({
    name  = "move-kitty-to-workspace-1",
    match = { class = "kitty" },
    workspace = 1,
})

-- Keep Zed in workspace 1
hl.window_rule({
    name  = "move-zed-to-workspace-1",
    match = { class = "dev.zed.Zed" },
    workspace = 1,
})

-- Keep Firefox in workspace 2
hl.window_rule({
    name  = "move-firefox-to-workspace-2",
    match = { class = "firefox" },
    workspace = 2,
})

-- Keep Discord in workspace 3
hl.window_rule({
    name  = "move-discord-to-workspace-3",
    match = { class = "discord" },
    workspace = 3,
})

-- Keep Telegram in workspace 3
hl.window_rule({
    name  = "move-telegram-to-workspace-3",
    match = { class = "org.telegram.desktop" },
    workspace = 3,
})

-- Keep Slack in workspace 3
hl.window_rule({
    name  = "move-slack-to-workspace-3",
    match = { class = "Slack" },
    workspace = 3,
})

-- Keep Steam in workspace 4
hl.window_rule({
    name  = "move-steam-to-workspace-4",
    match = { class = "steam" },
    workspace = 4,
})

-- Floating steam sub windows - centered on screen
-- Note: This rule floats and centers Steam windows
hl.window_rule({
    name  = "float-steam-sub-windows",
    match = { class = "steam" },
    float = true,
    center = true,
})

hl.window_rule({
    name  = "float-steam-app-windows",
    match = { class = "steam_app_.*" },
    float = true,
    center = true
})

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
