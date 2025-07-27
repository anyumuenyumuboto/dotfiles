-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()

-- 背景透過
-- config.window_background_opacity = 0.70
config.window_background_opacity = 1.00

-- 最初からフルスクリーンで起動
-- local mux = wezterm.mux
-- wezterm.on("gui-startup", function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)

-- カラースキームの設定
-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Solarized Light (Gogh)'
-- config.color_scheme = 'Iceberg (Gogh)'
config.color_scheme = "iceberg-light"
-- config.color_scheme = 'Pencil Light (Gogh)'

-- PowerShell Core (pwsh.exe) をデフォルトのシェルとして設定
-- config.default_prog = { 'powershell.exe' }
config.default_prog = { 'pwsh.exe' }

-- 共通部分省略
-- ref [最高のターミナル環境を手に入れろ！WezTermに入門してみた。 | DevelopersIO](https://dev.classmethod.jp/articles/wezterm-get-started/)

wezterm.on("decrease-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	end
	overrides.window_background_opacity = overrides.window_background_opacity - 0.1
	if overrides.window_background_opacity < 0.1 then
		overrides.window_background_opacity = 0.1
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("increase-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	end
	overrides.window_background_opacity = overrides.window_background_opacity + 0.1
	if overrides.window_background_opacity > 1.0 then
		overrides.window_background_opacity = 1.0
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	-- 中略
	-- {
	-- 	key = "n",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action({ EmitEvent = "decrease-opacity" }),
	-- },
	-- {
	-- 	key = "m",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action({ EmitEvent = "increase-opacity" }),
	-- },
	{ key = "E", mods = "ALT", action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }) },
}

-- ref [alacritty+tmuxもいいけど、weztermがすごい件](https://zenn.dev/yutakatay/articles/wezterm-intro)
wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
	local scrollback = pane:get_lines_as_text()
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(scrollback)
	f:flush()
	f:close()
	window:perform_action(
		wezterm.action({ SpawnCommandInNewTab = {
			args = { "nvim", name },
		} }),
		pane
	)
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

return config
