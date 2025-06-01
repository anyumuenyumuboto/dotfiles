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
		-- { "iamcco/markdown-preview.nvim" },
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
		{'yasukotelin/shirotelin'},
		{'cocopon/iceberg.vim'},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- install = { colorscheme = { "shirotelin" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- Lua Language Server を有効化
-- ref [GitHub - neovim/nvim-lspconfig: Quickstart configs for Nvim LSP](https://github.com/neovim/nvim-lspconfig)
-- ref [nvim-lspconfig/doc/configs.md at master · neovim/nvim-lspconfig · GitHub](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls)
-- vim.lsp.enable('lua_ls')

-- TypeScript Language Server を有効化
-- vim.lsp.enable("ts_ls")
-- Haskell Language Server を有効化
vim.lsp.enable("hls")

-- ref [VimでgfしたらURLをブラウザで開く | Atusy's blog](https://blog.atusy.net/2023/12/09/gf-open-url/)
vim.keymap.set("n", "gf", function()
	local cfile = vim.fn.expand("<cfile>") -- カーソル下の単語（ファイルパス）を取得
	if cfile:match("^https?://") then
		-- vim.ui.open(cfile)  -- URL の場合はブラウザで開く
		if vim.fn.has("win32") then
			vim.fn.system("start " .. cfile)
		else
			vim.fn.system("xdg-open " .. cfile) -- Linux/macOSの場合
		end
	else
		vim.cmd("normal! gF") -- ファイルを開く
	end
end)

-- WSL環境でのみクリップボード設定を有効にする
-- ref [WSL×NeoVim(init.lua) クリップボードにコピーできるようにする方法 #neovim - Qiita](https://qiita.com/hwatahik/items/32279372ea7182d75677)
-- ref [lua - Copy into system clipboard from neovim - Stack Overflow](https://stackoverflow.com/questions/75548458/copy-into-system-clipboard-from-neovim) 
if os.getenv("WSL_DISTRO_NAME") then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = true,
  }
end

-- colorschemeを設定する
-- vim.cmd("colorscheme morning")
-- vim.cmd("colorscheme shirotelin")
vim.cmd("colorscheme iceberg")
-- 背景色を設定する
vim.cmd("set background=light")

-- init.luaのあるフォルダを開く
vim.api.nvim_create_user_command("ConfigNvim", function()
	local nvim_config_dir = nil
	-- [Vim / NeovimでOS別に設定を切り替える](https://zenn.dev/grtw2116/articles/83b0e7daa6e0b7)
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
