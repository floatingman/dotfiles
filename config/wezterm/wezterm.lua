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
    -- Catppuccin Mocha colors
    return {
      foreground = "#CAD3F5",
      background = "#24273A",
      cursor_bg = "#F4DBD6",
      cursor_fg = "#24273A",
      cursor_border = "#F4DBD6",
      selection_fg = "#24273A",
      selection_bg = "#F4DBD6",
      scrollbar_thumb = "#181926",
      split = "#181926",

      ansi = { "#494D64", "#ED8796", "#A6DA95", "#EED49F", "#8AADF4", "#F5BDE6", "#8BD5CA", "#B8C0E0" },
      brights = { "#5B6078", "#ED8796", "#A6DA95", "#EED49F", "#8AADF4", "#F5BDE6", "#8BD5CA", "#A5ADCB" },
    }
  else
    -- Catppuccin Latte colors
    return {
      foreground = "#4C4F69",
      background = "#EFF1F5",
      cursor_bg = "#DC8A78",
      cursor_fg = "#EFF1F5",
      cursor_border = "#DC8A78",
      selection_fg = "#EFF1F5",
      selection_bg = "#DC8A78",
      scrollbar_thumb = "#DCE0E8",
      split = "#DCE0E8",

      ansi = { "#5C5F77", "#D20F39", "#40A02B", "#DF8E1D", "#1E66F5", "#EA76CB", "#179299", "#ACB0BE" },
      brights = { "#6C6F85", "#D20F39", "#40A02B", "#DF8E1D", "#1E66F5", "#EA76CB", "#179299", "#BCC0CC" },
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
