----------------
--- MONITORS ---
----------------
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "desc: LG Electronics LG ULTRAGEAR+", mode = "3440x1440", position = "auto", scale = 1 })
hl.monitor({ output = "desc: Hisense Electric Co.", mode = "1920x1080", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-------------------
--- MY PROGRAMS ---
-------------------
local terminal_name = "Terminal"
local terminal = "kitty --title " .. terminal_name
local fileManager = "nautilus"
local menu = "rofi -show drun -show-icons"
local notif = "swaync"
local browser = "firefox"
local editor = terminal .. " nvim"
local editor_prog = terminal .. " -d ~/prog nvim"

-----------------
--- AUTOSTART ---
-----------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("sleep 1 && waybar")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("[workspace 1] " .. terminal)
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("[workspace 2 silent] " .. browser)
    hl.exec_cmd("[workspace 3 silent] " .. editor_prog)
    hl.exec_cmd("[workspace 4 silent] ~/.config/scripts/spotify-opener.sh")
    hl.exec_cmd("~/.config/scripts/spotify-notify.sh")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------
hl.env("HYPRCURSOR_THEME", "Future-Cyan-Hyprcursor_Theme")
hl.env("HYPRCURSOR_SIZE", "40")
hl.env("XCURSOR_THEME", "Future-cyan-cursors")
hl.env("XCURSOR_SIZE", "32")

---------------------
--- LOOK AND FEEL ---
---------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 0,
        border_size = 0,
        ["col.active_border"] = "rgba(16161Dff)",
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 4,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.01,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        initial_workspace_tracking = 1,
    },
    input = {
        kb_layout = "br",
        follow_mouse = 1,
        sensitivity = -0.5,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.5,
        },
    },
})

hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "fade" })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "gxtp5100:00-27c6:01e0-touchpad",
    scroll_factor = 0.5,
    sensitivity = 0.4,
    accel_profile = "flat",
})

-------------------------
--- WORKSPACE MAPPING ---
-------------------------
hl.workspace_rule({ workspace = 1, monitor = "DP-1" })
hl.workspace_rule({ workspace = 2, monitor = "DP-1" })
hl.workspace_rule({ workspace = 3, monitor = "DP-1" })
hl.workspace_rule({ workspace = 4, monitor = "DP-1" })

-------------------
--- KEYBINDINGS ---
-------------------
local mainMod = "SUPER"
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.kill())
hl.bind(
    mainMod .. "+ M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. "+ L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. "+ F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. "+ E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. "+ V", hl.dsp.window.float())
hl.bind(mainMod .. "+ space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. "+ P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. "+ J", "layoutmsg", "togglesplit")
hl.bind(mainMod .. "+ Print", hl.dsp.exec_cmd("hyprshot -o ~/Images/Prints/ -m region"))
hl.bind(mainMod .. "+ B", hl.dsp.exec_cmd(browser))
hl.bind(
    mainMod .. "+ SHIFT + P",
    hl.dsp.exec_cmd("rofi -config ~/.config/rofi/config_power_menu.rasi -show p -modi p:rofi-power-menu")
)
hl.bind(mainMod .. "+ SHIFT + E", hl.dsp.exec_cmd("~/.config/scripts/monitor_extend.sh"))
hl.bind(mainMod .. "+ SHIFT + M", hl.dsp.exec_cmd("~/.config/scripts/monitor_mirror.sh"))

hl.bind(mainMod .. "+ left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. "+ right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. "+ up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "+ down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + CONTROL + 1", hl.dsp.workspace.move({ monitor = "eDP-1" }))
hl.bind(mainMod .. " + CONTROL + 2", hl.dsp.workspace.move({ monitor = "HDMI-A-1" }))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------------------------
--- WINDOW RULES AND WORKSPACES  ---
------------------------------------
hl.window_rule({
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    match = { class = "^$", title = "^$", xwayland = 1, float = 1, fullscreen = 0, pin = 0 },
    no_initial_focus = true,
})

hl.window_rule({
    match = { initial_class = "^(com\\.example\\..*)$" },
    float = true,
    workspace = "special:magic",
})

hl.window_rule({
    match = { initial_class = "^(Spotify)$" },
    workspace = "4 silent",
})

hl.window_rule({
    match = { class = "^(kitty-sinkswitch)$" },
    float = true,
    move = "1300 54",
    size = "400 160",
    monitor = "DP-1",
})
