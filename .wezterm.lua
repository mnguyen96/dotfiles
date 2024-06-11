local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
config.color_scheme = "Catppuccin Macchiato"
config.keys = {
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
	-- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
	{ key = "8", mods = "CTRL", action = act.PaneSelect },
	-- activate pane selection mode with numeric labels
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

config.initial_cols = 120
config.initial_rows = 40
return config
