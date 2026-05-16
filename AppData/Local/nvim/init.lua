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
		{ "glacambre/firenvim", build = ":call firenvim#install(0)" },
		-- nvim v0.8.0
		{
			"romgrk/barbar.nvim",
			enabled = not vim.g.started_by_firenvim, -- Firenvim環境では無効化
			dependencies = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
			init = function()
				vim.g.barbar_auto_setup = false
			end,
			opts = {
				-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
				-- animation = true,
				-- insert_at_start = true,
				-- …etc.
			},
			version = "^1.0.0", -- optional: only update when a new 1.x version is released
		},
		{
			"nvim-lualine/lualine.nvim",
			enabled = not vim.g.started_by_firenvim, -- Firenvim環境では無効化
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
						refresh_time = 16, -- ~60fps
						events = {
							"WinEnter",
							"BufEnter",
							"BufWritePost",
							"SessionLoadPost",
							"FileChangedShellPost",
							"VimResized",
							"Filetype",
							"CursorMoved",
							"CursorMovedI",
							"ModeChanged",
						},
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			},
		},
		{
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			-- optional for floating window border decoration
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			-- setting the keybinding for LazyGit with 'keys' is recommended in
			-- order to load the plugin when the command is run for the first time
			keys = {
				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
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
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				on_attach = function(bufnr)
					-- ノーマルモードで適用
					vim.keymap.set("n", "]c", function()
						require("gitsigns").next_hunk()
					end, { desc = "Next Git hunk" })
					vim.keymap.set("n", "[c", function()
						require("gitsigns").prev_hunk()
					end, { desc = "Previous Git hunk" })
				end,
			},
		},

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
-- Nushell built-in language server を有効化
vim.lsp.enable("nushell")

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

-- [romgrk/barbar.nvim: The neovim tabline plugin.](https://github.com/romgrk/barbar.nvim/)
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- [glacambre/firenvim: Embed Neovim in Chrome, Firefox & others.](https://github.com/glacambre/firenvim)
-- [生成AI時代だからこそ、Vim as an IME](https://zenn.dev/dog/articles/vim-as-an-ime#firenvim-%E3%82%92%E4%BD%BF%E3%81%86%E4%B8%8A%E3%81%A7%E3%81%AE-tips)
if vim.g.started_by_firenvim == true then
	-- 一般的なウェブ入力欄に近づける設定
	vim.opt.signcolumn = "no"
	vim.opt.laststatus = 0
	vim.opt.background = "light"
	vim.opt.cursorline = false
	vim.opt.number = false
	vim.opt.fillchars:append({ eob = " " })
	-- 必要に応じてカラースキームやStatuslineも調整
	vim.cmd.colorscheme("shine") -- 例: シンプルなテーマに変更
	-- vim.g.ministatusline_disable = true -- 例: mini.nvimのステータスラインを無効化
	-- 保存メッセージを非表示にする
	map("n", ":w<CR>", ":silent! write<CR>", opts)
end

-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)

-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)

-- ヤンク範囲が一瞬ハイライトされるようにする
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
