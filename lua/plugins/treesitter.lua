return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-context" },
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
		},
		config = function()
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			require("nvim-treesitter.install").prefer_git = true

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = require("nixCatsUtils").lazyAdd({
					"bash",
					"c",
					"html",
					"lua",
					"markdown",
					"javascript",
					"typescript",
					"tsx",
					"svelte",
					"css",
					"json",
					"vim",
					"vimdoc",
					"clojure",
					"go",
				}),
				-- Autoinstall languages that are not installed
				auto_install = require("nixCatsUtils").lazyAdd(true, false),
				highlight = { enable = true },
				indent = { enable = true },
			})

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
}
