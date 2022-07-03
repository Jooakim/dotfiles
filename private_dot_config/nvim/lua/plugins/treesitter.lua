require("nvim-treesitter.configs").setup({
	ensure_installed = { "java", "lua", "python", "json", "javascript" },
	refactor = {
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},
})
