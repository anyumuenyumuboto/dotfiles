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
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
		},
		{
			"A7Lavinraj/fyler.nvim",
			dependencies = { "nvim-mini/mini.icons" },
			lazy = false, -- Necessary for `default_explorer` to work properly
			opts = {},
		},
		{ "machakann/vim-sandwich" },
		{
			"nacro90/numb.nvim",
			config = function()
				require("numb").setup()
			end,
		},

		{
			"OXY2DEV/markview.nvim",
			lazy = false,

			-- For blink.cmp's completion
			-- source
			-- dependencies = {
			--     "saghen/blink.cmp"
			-- },
		},
		{ "lewis6991/gitsigns.nvim" },

		-- ref [Neovimにeskk.vimをインストールする](https://zenn.dev/laddge/articles/9f12f362171159)
		{
			"vim-skk/eskk.vim",
			config = function()
				vim.g["eskk#large_dictionary"] =
					{ path = "~/AppData/Local/nvim/SKK-JISYO.L", sorted = 1, encoding = "euc-jp" }
			end,
		},
		{ "neovim/nvim-lspconfig" },
		{ "cocopon/iceberg.vim" },
		{ "tyru/open-browser.vim", event = "VeryLazy" },
		{
			"brianhuster/live-preview.nvim",
			ft = { "markdown" },
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
			"anyumuenyumuboto/auto-file-name.nvim", -- Replace with your actual GitHub repository path
			-- branch = "develop",
			config = function()
				require("autofilename").setup({
					-- Set your options here
					-- Example:
					-- extension = ".txt",
					-- filename_format = "{{strftime:%Y-%m-%d}}_{{first_line}}",
					-- lang = "en", -- 'en', 'ja', 'zh-CN'
					ai_server_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
					ai_api_key = vim.env.API_KEY,
				})
			end,
		},
		{
			"voldikss/vim-translator",
			event = "VeryLazy",
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
			event = "VeryLazy",
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
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- install = { colorscheme = { "shirotelin" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- Language Server を有効化する
-- ref [GitHub - neovim/nvim-lspconfig: Quickstart configs for Nvim LSP](https://github.com/neovim/nvim-lspconfig)
-- ref [nvim-lspconfig/doc/configs.md at master · neovim/nvim-lspconfig · GitHub](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
-- Lua Language Server を有効化
vim.lsp.enable("lua_ls")
-- TypeScript Language Server を有効化
vim.lsp.enable("ts_ls")
-- Haskell Language Server を有効化
vim.lsp.enable("hls")
-- Purescript Language Server を有効化
vim.lsp.enable("purescriptls")
-- rust-analyzer (aka rls 2.0), a language server for Rust
vim.lsp.enable("rust_analyzer")

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

-- Neovimで、windowsの場合、ExコマンドモードでPowerShell を使うように設定する
if vim.fn.has("win64") == 1 then
	vim.opt.shell = "pwsh"
	vim.o.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command \"$PSStyle.OutputRendering='PlainText';\""
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end
