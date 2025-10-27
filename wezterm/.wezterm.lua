local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local config = wezterm.config_builder()
local act = wezterm.action

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("MesloLGL Nerd Font")
config.window_decorations = "RESIZE"
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.hide_tab_bar_if_only_one_tab = true
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{
		key = "h",
		mods = "CTRL|CMD",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "j",
		mods = "CTRL|CMD",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{ key = "k", mods = "CTRL|CMD", action = act.AdjustPaneSize({ "Up", 5 }) },
	{
		key = "l",
		mods = "CTRL|CMD",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "K",
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "J",
		mods = "CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "g", mods = "CTRL", action = wezterm.action.ActivateCopyMode },
	{
		key = "y",
		mods = "",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
			else
				window:perform_action(act.SendKey({ key = "y", mods = "" }), pane)
			end
		end),
	},
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "z",
		mods = "CTRL",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
}
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.5,
}
config.max_fps = 120
-- must be at the end
smart_splits.apply_to_config(config)
return config
