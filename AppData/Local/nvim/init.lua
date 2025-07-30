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
		-- {
		-- 	"ksudate/prev-md.vim",
		-- 	config = function()
		-- 		vim.g.prev_md_preview_location = "right"
		-- 		vim.g.prev_md_preview_width = 80
		-- 		vim.keymap.set("n", "<leader>mp", "<cmd>PrevMDToggle<cr>", { desc = "Toggle Markdown Preview" })
		-- 	end,
		-- },
		-- ref [Neovimにeskk.vimをインストールする](https://zenn.dev/laddge/articles/9f12f362171159)
		{
			"vim-skk/eskk.vim",
			config = function()
				vim.g["eskk#large_dictionary"] =
					{ path = "~/AppData/Local/nvim/SKK-JISYO.L", sorted = 1, encoding = "euc-jp" }
			end,
		},
		{ "aklt/plantuml-syntax" },
		{ "neovim/nvim-lspconfig" },
		{ "cocopon/iceberg.vim" },
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
			-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
			-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
			---@module 'render-markdown'
			-- -@type render.md.UserConfig
			opts = {},
		},
		{ "tyru/open-browser.vim" },
		-- { "previm/previm" },
		{
			"brianhuster/live-preview.nvim",
			dependencies = {
				-- You can choose one of the following pickers
				"nvim-telescope/telescope.nvim",
				"ibhagwan/fzf-lua",
				"echasnovski/mini.pick",
			},
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
		{ "mfussenegger/nvim-dap" },
		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
		{ "theHamsta/nvim-dap-virtual-text" },
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration

				-- Only one of these is needed.
				"nvim-telescope/telescope.nvim", -- optional
				"ibhagwan/fzf-lua", -- optional
				"echasnovski/mini.pick", -- optional
				"folke/snacks.nvim", -- optional
			},
		},
		{
			"yetone/avante.nvim",
			-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
			-- ⚠️ must add this setting! ! !
			build = function()
				-- conditionally use the correct build system for the current OS
				if vim.fn.has("win32") == 1 then
					return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
				else
					return "make"
				end
			end,
			event = "VeryLazy",
			version = false, -- Never set this value to "*"! Never!
			---@module 'avante'
			---@type avante.Config
			opts = {
				-- add any opts here
				-- for example
				-- provider = "claude",
				provider = "gemini",
				-- providers = {
				--   claude = {
				--     endpoint = "https://api.anthropic.com",
				--     model = "claude-sonnet-4-20250514",
				--     timeout = 30000, -- Timeout in milliseconds
				--       extra_request_body = {
				--         temperature = 0.75,
				--         max_tokens = 20480,
				--       },
				--   },
				-- },
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				--- The below dependencies are optional,
				"echasnovski/mini.pick", -- for file_selector provider mini.pick
				"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
				"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
				"ibhagwan/fzf-lua", -- for file_selector provider fzf
				"stevearc/dressing.nvim", -- for input provider dressing
				"folke/snacks.nvim", -- for input provider snacks
				"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
				"zbirenbaum/copilot.lua", -- for providers='copilot'
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							-- required for Windows users
							use_absolute_path = true,
						},
					},
				},
				{
					-- Make sure to set this up properly if you have lazy=true
					"MeanderingProgrammer/render-markdown.nvim",
					opts = {
						file_types = { "markdown", "Avante" },
					},
					ft = { "markdown", "Avante" },
				},
				{
					"anyumuenyumuboto/auto-file-name.nvim", -- Replace with your actual GitHub repository path
					config = function()
						require("autofilename").setup({
							-- Set your options here
							-- Example:
							-- extension = ".txt",
							-- filename_format = "{{strftime:%Y-%m-%d}}_{{first_line}}",
							-- lang = "en", -- 'en', 'ja', 'zh-CN'
						})
					end,
				},
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
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- install = { colorscheme = { "shirotelin" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- lazydev.nvim を使用して、nvim-dap-ui の型チェックを有効にして取得する
-- [rcarriga/nvim-dap-ui: A UI for nvim-dap](https://github.com/rcarriga/nvim-dap-ui)
-- require("lazydev").setup({
--   library = { "nvim-dap-ui" },
-- })

-- Language Server を有効化する
-- ref [GitHub - neovim/nvim-lspconfig: Quickstart configs for Nvim LSP](https://github.com/neovim/nvim-lspconfig)
-- ref [nvim-lspconfig/doc/configs.md at master · neovim/nvim-lspconfig · GitHub](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls)
-- Lua Language Server を有効化
vim.lsp.enable("lua_ls")
-- TypeScript Language Server を有効化
-- vim.lsp.enable("ts_ls")
-- Haskell Language Server を有効化
-- vim.lsp.enable("hls")

-- WSL環境でのみクリップボード設定を有効にする
-- ref [WSL×NeoVim(init.lua) クリップボードにコピーできるようにする方法 #neovim - Qiita](https://qiita.com/hwatahik/items/32279372ea7182d75677)
-- ref [lua - Copy into system clipboard from neovim - Stack Overflow](https://stackoverflow.com/questions/75548458/copy-into-system-clipboard-from-neovim)
if os.getenv("WSL_DISTRO_NAME") then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = true,
	}
end

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

-- Neovimで、windowsの場合、ExコマンドモードでPowerShell を使うように設定する
if vim.fn.has("win64") == 1 then
	-- vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
	-- vim.opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command'
	vim.opt.shell = "pwsh"
	vim.o.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command \"$PSStyle.OutputRendering='PlainText';\""
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

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
