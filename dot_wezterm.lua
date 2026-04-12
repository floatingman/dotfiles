local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- Get theme from theme state file
function get_theme()
  -- Try to read from i3 theme state file
  local theme_file = wezterm.home_dir .. "/.cache/i3/current-theme"
  local file = io.open(theme_file, "r")
  if file then
    local theme = file:read("*line"):lower()
    file:close()
    if theme == "light" then
      return "Light"
    else
      return "Dark"
    end
  end

  -- Fall back to system appearance detection
  if wezterm.gui then
    local appearance = wezterm.gui.get_appearance()
    return appearance
  end
  return "Dark"
end

function scheme_for_appearance(appearance)
  if appearance:find("Dark") or appearance == "Dark" then
    -- Gruvbox Dark colors
    return {
      foreground = "#ebdbb2",
      background = "#282828",
      cursor_bg = "#ebdbb2",
      cursor_fg = "#282828",
      cursor_border = "#ebdbb2",
      selection_fg = "#ebdbb2",
      selection_bg = "#45403d",
      scrollbar_thumb = "#504945",
      split = "#3c3836",

      ansi = { "#282828", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#a89984" },
      brights = { "#928374", "#fb4934", "#b8bb26", "#fabd2f", "#83a598", "#d3869b", "#8ec07c", "#7c6f64" },
    }
  else
    -- Gruvbox Light colors
    return {
      foreground = "#504945",
      background = "#fbf1c7",
      cursor_bg = "#504945",
      cursor_fg = "#fbf1c7",
      cursor_border = "#504945",
      selection_fg = "#fbf1c7",
      selection_bg = "#423b34",
      scrollbar_thumb = "#d5c4a1",
      split = "#ebdbb2",

      ansi = { "#fbf1c7", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#7c6f64" },
      brights = { "#d5c4a1", "#9d0006", "#79740e", "#b57614", "#076678", "#8f3f71", "#427b58", "#3c3836" },
    }
  end
end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

local colors = scheme_for_appearance(get_theme())

return {
  colors = colors,
  enable_tab_bar = false,
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14,
  line_height = 1.2,
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  },
  -- macos_window_background_blur = 40,
  macos_window_background_blur = 30,

  -- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
  window_background_image_hsb = {
    brightness = 0.01,
    hue = 1.0,
    saturation = 0.5,
  },
  window_background_opacity = 1.00,
  -- window_background_opacity = 1.0,
  -- window_background_opacity = 0.78,
  -- window_background_opacity = 0.20,
  window_decorations = "RESIZE",
  window_frame = {
    font = wezterm.font({ family = "Noto Sans", weight = "Regular" }),
  },
  disable_default_key_bindings = true,
  leader = { key = "b", mods = "ALT", timeout_milliseconds = 2000 },

  keys = {
    { key = "l", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },
    { key = "h", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
    { key = "Enter", mods = "ALT", action = act.ActivateCopyMode },
    { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = act.ResetFontSize },
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
    {
      key = "U",
      mods = "SHIFT|CTRL",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    { key = "v", mods = "ALT", action = act.PasteFrom("Clipboard") },
    { key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
    { key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
    { key = "f", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
    { key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
    { key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "b", mods = "LEADER|CTRL", action = act.SendString("\x02") },
    { key = "Enter", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "p", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
    {
      key = "k",
      mods = "CTRL|ALT",
      action = act.Multiple({
        act.ClearScrollback("ScrollbackAndViewport"),
        act.SendKey({ key = "L", mods = "CTRL" }),
      }),
    },
    { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  },
  use_dead_keys = false,
  scrollback_lines = 10000,
  adjust_window_size_when_changing_font_size = false,
  hide_tab_bar_if_only_one_tab = true,
}
