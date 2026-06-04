---@diagnostic disable: undefined-global

----------------
-- MONITORS
-- Docs: https://wiki.hypr.land/Configuring/Monitors
----------------
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 }) -- fallback for unknown monitors
-- To add a monitor: hl.monitor({ output = "NAME", mode = "WxH@Hz", position = "XxY", scale = N })
-- To disable: hl.monitor({ output = "NAME", disabled = true })
----------------
-- PROGRAMS
-- Edit these to change what apps open for each action
----------------
local terminal = "foot"
local fileManager = "dolphin"
local menu = "fuzzel"
local browser = "helium-browser"
local config_search = "/home/neon/.config/fuzzel/config-search"
local clip_ocr = "/home/neon/.local/bin/clip-ocr"
----------------
-- AUTOSTART
-- Runs on Hyprland startup. Add entries with hl.exec_cmd("command")
----------------
hl.on("hyprland.start", function()
hl.exec_cmd("waybar")
hl.exec_cmd("kbuildsycoca6")
hl.exec_cmd("fcitx5")
hl.exec_cmd("wl-paste --watch cliphist store")
hl.exec_cmd("wl-clip-persist --clipboard regular")
hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
hl.exec_cmd("hyprpm reload")

end)
----------------
-- ENVIRONMENT
-- Docs: https://wiki.hypr.land/Configuring/Environment-variables
----------------
hl.env("AQ_NO_HARDWARE_CURSORS", "1")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
-- NVIDIA memory tuning:
--   AQ_NO_MODIFIERS: reduces DRM buffer allocations (NVIDIA GPU pools)
--   __GL_SHADER_DISK_CACHE: ensures shaders compile to disk, keeps LLVM pages reclaimable
hl.env("AQ_NO_MODIFIERS", "1")
hl.env("__GL_SHADER_DISK_CACHE", "1")
hl.env("__GL_SHADER_DISK_CACHE_PATH", "$HOME/.cache/nvidia")
-- GTK/QT IM_MODULE should NOT be set on Wayland (native IM protocol only)
-- Setting them causes duplicate characters with fcitx5 Lotus
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
----------------
-- LOOK AND FEEL
-- Docs: https://wiki.hypr.land/Configuring/Variables
----------------
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 1,
    col = {
      active_border = "rgba(ccccccaa)",
          inactive_border = "rgba(595959aa)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 0,
    rounding_power = 0,
    active_opacity = 1.0,
    inactive_opacity = 0.9,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = false,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  -- Docs: https://wiki.hypr.land/Configuring/Animations
  animations = {
    enabled = true,
  },
  -- Docs: https://wiki.hypr.land/Configuring/Dwindle-Layout
  dwindle = {
    preserve_split = true,
  },
  -- Docs: https://wiki.hypr.land/Configuring/Master-Layout
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = 0,
      disable_hyprland_logo = false,
      disable_splash_rendering = true,
      initial_workspace_tracking = 1,
  },
  -- Docs: https://wiki.hypr.land/Configuring/Variables/#input
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    accel_profile = "flat",
    sensitivity = 0.25,
    touchpad = {
      natural_scroll = false,
    },
  },
})
----------------
-- ANIMATIONS
-- Bezier curves define easing, then applied to animation leaves
-- Docs: https://wiki.hypr.land/Configuring/Animations
----------------
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
-- Common styles: popin, fade. Speed = animation duration multiplier.
----------------
-- INPUT DEVICES / GESTURES
-- Docs: https://wiki.hypr.land/Configuring/Gestures
----------------
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
-- Per-device config: https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
----------------
-- KEYBINDS
-- Docs: https://wiki.hypr.land/Configuring/Binds
--
-- hl.dsp helpers map to internal dispatchers:
--   hl.dsp.window.close()       → killactive
--   hl.dsp.window.fullscreen()  → fullscreen
--   hl.dsp.window.float()       → togglefloating
--   hl.dsp.window.pseudo()      → pseudotile
--   hl.dsp.layout("togglesplit") → togglesplit
--   hl.dsp.exec_cmd("...")      → exec (run shell command)
--   hl.dsp.focus({direction=})  → movefocus
--   hl.dsp.focus({workspace=})  → workspace
--   hl.dsp.window.move({workspace=}) → movetoworkspace
--   hl.dsp.exit()               → exit
----------------
local mainMod = "SUPER"
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("~/.local/bin/fuzzel-wallpaper.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill waybar && waybar &"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(clip_ocr))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd('/home/neon/.local/bin/void-pet screenshot'))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(config_search))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd('/home/neon/.local/bin/ss-pet'))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("nwg-drawer"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/fuzzel/power_menu.sh"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("/home/neon/.config/fuzzel/clipboard-search.sh"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("thunderbird"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("/home/neon/.local/bin/yt-music-dl"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("foot --app-id=meme-picker --title='Meme Collection' ~/.config/memes/meme-pick"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("~/.config/memes/meme-capture"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("~/.config/memes/meme-crop"))




for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  end
  hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
  hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
  hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
  hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
  -- Media / brightness keys
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
  hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
  hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
  ----------------
  -- WINDOW RULES
  -- Docs: https://wiki.hypr.land/Configuring/Window-Rules
  ----------------
  hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
  })
  -- Fix some dragging issues with XWayland
  hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
      class = "^$",
      title = "^$",
      xwayland = true,
      float = true,
      fullscreen = false,
      pin = false,
    },
    no_focus = true,
  })
  hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
  })
  hl.window_rule({
    name = "mcpelauncher-client-float",
    match = { class = "mcpelauncher-client" },
    float = true,
  })
  hl.window_rule({
    name = "mcpelauncher-client-size",
    match = { class = "mcpelauncher-client" },
    size = "1900 999",
  })
  hl.window_rule({
    name = "mcpelauncher-client-move",
    match = { class = "mcpelauncher-client" },
    move = "((monitor_w - window_w) / 2) 0",
  })
  hl.window_rule({
    name = "dolphin-opacity",
    match = { class = "^(dolphin)$" },
    opacity = "0.90 override 0.90 override"
  })
  hl.window_rule({
    name = "meme-picker",
    match = { class = "meme-picker" },
    float = true,
    size = "1000 700",
    opacity = "0.92 override 0.92 override",
  })
  ----------------
  -- OVERVIEW / HYPRSPACE
  ----------------
  hl.config({ plugin = { hyprspace = {
    draw_active_workspace = true,
--     hide_background_layers = true,
--     hide_top_layers = true,
--     hide_overlay_layers = true,
--     hide_real_layers = true,
    panel_color = 0x00000000,
    panel_border_width = 0,
    panel_border_color = 0x00000000,
    disable_blur = true,
    affect_strut = false,
    auto_scroll = false,
    auto_drag = false,
 override_gaps = false,
 center_aligned = true,
 } } })

hl.unbind(mainMod .. " + TAB")
  hl.bind(mainMod .. " + TAB", function()
    if hl.plugin and hl.plugin.Hyprspace and type(hl.plugin.Hyprspace.overview) == "function" then
      hl.plugin.Hyprspace.overview("toggle")
    end
  end)
