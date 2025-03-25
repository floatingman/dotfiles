-- Pull in the wezterm API
local wezterm = require("wezterm")
local time = wezterm.time.now()
local sun_times = time:sun_times(36.16, -86.78)
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("JetBrains Mono")
-- config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Solarized (dark) (terminal.sexy)"
-- config.color_scheme = "AdventureTime"
-- config.color_scheme = "Solarized (light) (terminal.sexy)"
-- and finally, return the configuration to wezterm

local light_scheme = "Ayu Light (Gogh)"
local dark_scheme = "Ayu Dark (Gogh)"

wezterm.on("toggle-color-scheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == light_scheme then
		overrides.color_scheme = dark_scheme
	else
		overrides.color_scheme = light_scheme
	end
	window:set_config_overrides(overrides)
end)

return {
	keys = {
		{
			key = "m",
			mods = "SHIFT|CTRL",
			action = wezterm.action({ EmitEvent = "toggle-color-scheme" }),
		},
	},
}
