-- ref [🛠️ Installation | lazy.nvim](https://lazy.folke.io/installation)
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"glepnir/template.nvim",
			cmd = { "Template", "TemProject" },
			config = function()
				require("template").setup({
					-- config in there
					temp_dir = vim.fn.stdpath("config") .. "/templates", -- Neovimの設定フォルダ内に templates ディレクトリを作成
					remove_trailing_spaces = false, -- 余分な空白削除を無効化（エラー回避）
					update_on_save = true, -- 保存時にテンプレートの更新を許可
				})
			end,
		},
		{
			"vim-skk/eskk.vim",
			config = function()
				vim.g["eskk#large_dictionary"] =
					{ path = "~/AppData/Local/nvim/SKK-JISYO.L", sorted = 1, encoding = "euc-jp" }
			end,
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
			},
			lazy = false, -- neo-tree will lazily load itself
			---@module "neo-tree"
			---@type neotree.Config?
			opts = {
				-- fill any relevant options here
			},
		},
		{ "sindrets/diffview.nvim" },
		{
			"voldikss/vim-translator",
			config = function()
				vim.g.translator_target_lang = "ja"
				vim.g.translator_default_engines = { "google" }
				vim.g.translator_history_enable = true
				-- vim.g.translator_window_type = "preview"
				vim.g.translator_window_max_width = 0.5
				vim.g.translator_window_max_height = 0.9 -- 1 is not working-
			end,
		},
		{
			"potamides/pantran.nvim",
			config = function()
				require("pantran").setup({
					default_engine = "google",
					engines = {
						google = {
							fallback = {
								default_source = "ja",
								default_target = "en",
							},
							-- NOTE: must set `DEEPL_AUTH_KEY` env-var
							-- deepl = {
							--   default_source = "",
							--   default_target = "",
							-- },
						},
					},
				})
			end,
		},
		{
			"anyumuenyumuboto/auto-file-name.nvim", -- Replace with your actual GitHub repository path
			config = function()
				require("autofilename").setup({
					ai_server_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
					ai_api_key = vim.env.GEMINI_API_KEY,
				})
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- install = { colorscheme = { "shirotelin" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- colorschemeを設定する
vim.cmd("colorscheme iceberg")
-- 背景色を設定する
vim.cmd("set background=light")

-- init.luaのあるフォルダを開く
vim.api.nvim_create_user_command("ConfigNvim", function()
	local nvim_config_dir = nil
	-- windowsの場合
	if vim.fn.has("win64") == 1 then
		nvim_config_dir = "~/AppData/Local/nvim/"
	-- linuxの場合
	elseif vim.fn.has("linux") == 1 then
		nvim_config_dir = "~/.config/nvim/"
	end
	vim.cmd("e " .. nvim_config_dir)
end, {})

-- 環境ごとの変数を読みこむ
local config_path = vim.fn.stdpath("config")
local config_local_path = config_path .. "/lua/config_local.lua"
local env_config = nil

if vim.fn.filereadable(config_local_path) == 1 then
	env_config = require("config_local")
	-- メモ用ディレクトリを開く
	if env_config.mynote_dir then
		vim.api.nvim_create_user_command("Mynote", function()
			vim.cmd("e " .. env_config.mynote_dir)
		end, {})
	end

	-- デイリーノートを開く
	if env_config.daily_note_dir then
		vim.api.nvim_create_user_command("DailyNote", function()
			local today = os.date("%Y-%m-%d")
			vim.cmd("e " .. env_config.daily_note_dir .. "daily_note_" .. today .. ".md")
		end, {})
	end

	-- untitled ファイルを開く
	if env_config.untitled_note_dir then
		vim.api.nvim_create_user_command("Untitled", function()
			local now = os.date("!%Y%m%dT%H%M%SZ", os.time())
			vim.cmd("e " .. env_config.untitled_note_dir .. "untitled_" .. now .. ".md")
		end, {})
	end
end

print("read init.lua!!!")
