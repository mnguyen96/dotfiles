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
	-- command + s save in mac
	{ mods = "CMD", key = "s", action = act.SendKey({ mods = "CTRL", key = "s" }) },
	{
		key = "d",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- scroll by line
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
	-- linux scroll by letter/words
	{ mods = "ALT", key = "LeftArrow", action = act.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "ALT", key = "RightArrow", action = act.SendKey({ mods = "ALT", key = "f" }) },
	-- mac scroll by letter/words
	{ mods = "OPT", key = "LeftArrow", action = act.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "OPT", key = "RightArrow", action = act.SendKey({ mods = "ALT", key = "f" }) },
	{ mods = "CMD", key = "LeftArrow", action = act.SendKey({ mods = "CTRL", key = "a" }) },
	{ mods = "CMD", key = "RightArrow", action = act.SendKey({ mods = "CTRL", key = "e" }) },
	{ mods = "CMD", key = "Backspace", action = act.SendKey({ mods = "CTRL", key = "u" }) },
	-- activate pane selection mode with numeric labels
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	-- Cycle to the next pane
	{ key = "l", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
	-- Cycle to the previous pane
	{ key = "h", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Prev" }) },
}

config.initial_cols = 120
config.initial_rows = 40
return config
