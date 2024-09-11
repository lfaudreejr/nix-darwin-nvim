require("nixCatsUtils").setup({
	non_nix_value = true,
})

require("options")
require("keybinds")
require("autocmds")

local pluginList = nil
local nixLazyPath = nil
if require("nixCatsUtils").isNixCats then
	print("using nixCats")

	-- Set to true if you have a Nerd Font installed and selected in the terminal
	-- NOTE: nixCats: we asked nix if we have it instead of setting it here.
	-- because nix is more likely to know if we have a nerd font or not.
	vim.g.have_nerd_font = nixCats("have_nerd_font")
	local allPlugins = require("nixCats").pawsible.allPlugins
	-- it is called pluginList because we only need to pass in the names
	-- this list literally just tells lazy.nvim not to download the plugins in the list.
	pluginList = require("nixCatsUtils.lazyCat").mergePluginTables(allPlugins.start, allPlugins.opt)

	-- it wasnt detecting that these were already added
	-- because the names are slightly different from the url.
	-- when that happens, add them to the list, then also specify the new name in the lazySpec
	pluginList[ [[Comment.nvim]] ] = ""
	pluginList[ [[LuaSnip]] ] = ""
	-- alternatively you can do it all in the plugins spec instead of modifying this list.
	-- just set the name and then add `dev = require('nixCatsUtils').lazyAdd(false, true)` to the spec

	-- HINT: to view the names of all plugins downloaded via nix, use the `:NixCats pawsible` command.

	-- we also want to pass in lazy.nvim's path
	-- so that the wrapper can add it to the runtime path
	-- as the normal lazy installation instructions dictate
	nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end
-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
	if require("nixCatsUtils").isNixCats and type(require("nixCats").settings.unwrappedCfgPath) == "string" then
		return require("nixCats").settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end
local lazyOptions = {
	lockfile = getlockfilepath(),
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
}

require("nixCatsUtils.lazyCat").setup(pluginList, nixLazyPath, {
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	-- NOTE: nixCats: nix downloads it with a different file name.
	-- tell lazy about that.
	{ "numToStr/Comment.nvim", name = "comment.nvim", opts = {} },
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VimEnter'
		-- opts = {
		-- 	defaults = {
		-- 		["<leader>b"] = { name = "[B]uffer", _ = "which_key_ignore" },
		-- 		["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
		-- 		["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
		-- 		["<leader>f"] = { name = "[F]iletree", _ = "which_key_ignore" },
		-- 		["<leader>l"] = { name = "[L]sp", _ = "which_key_ignore" },
		-- 		["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
		-- 		["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
		-- 		["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
		-- 	}
		-- },
		config = function() -- This is the function that runs, AFTER loading
			local wk = require("which-key")
			wk.add({
				{ "<leader>1", hidden = true },
				{ "<leader>2", hidden = true },
				{ "<leader>3", hidden = true },
				{ "<leader>4", hidden = true },
				{ "<leader>5", hidden = true },
				{ "<leader>a", hidden = true }, -- group
				{ "<leader>b", group = "[B]uffer" }, -- group
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>f", group = "[F]iletree" },
				{ "<leader>l", group = "[L]sp" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
			})
			wk.setup({
				preset = "modern",
			})
			-- require("which-key").setup()

			-- Document existing key chains
			-- require("which-key").register({
			-- 	["<leader>b"] = { name = "[B]uffer", _ = "which_key_ignore" },
			-- 	["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
			-- 	["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
			-- 	["<leader>f"] = { name = "[F]iletree", _ = "which_key_ignore" },
			-- 	["<leader>l"] = { name = "[L]sp", _ = "which_key_ignore" },
			-- 	["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
			-- 	["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			-- 	["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			-- })
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufEnter",
		config = function()
			require("colorizer").setup({
				filetypes = { "css", "html", "javascript", "lua", "toml" },
			})
		end,
	},
	{ import = "plugins" },
}, lazyOptions)

vim.cmd([[colorscheme solarized-osaka]])
