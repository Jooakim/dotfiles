-- Setup packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	Packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	--- Misc
	use("nvim-lua/plenary.nvim")
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
				},
			})
		end,
	})
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	-- Git
	use("tpope/vim-fugitive")

	--- Visuals
	use({ "sainnhe/gruvbox-material" })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-refactor" })
	use({ "nvim-treesitter/nvim-treesitter-context" })
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				globalstatus = true,
			})
		end,
	})
	use({ "kevinhwang91/nvim-bqf", ft = "qf" })
	use({ "vimpostor/vim-tpipeline" })

	--- LSP
	use({ "williamboman/nvim-lsp-installer" })
	use({
		"neovim/nvim-lspconfig",
		after = "nvim-lsp-installer",
		-- module = "lspconfig",
		config = function()
			require("plugins.lsp_installer")
			require("plugins.lspconfig")
		end,
		requires = { "hrsh7th/cmp-nvim-lsp" },
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.null-ls")
		end,
	})

	--- Telescope/Movement
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("plugins.telescope")
		end,
	})

	use("nvim-telescope/telescope-project.nvim")
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	require("telescope").load_extension("project")
	require("telescope").load_extension("file_browser")

	use({
		"ggandor/lightspeed.nvim",
		requires = { "tpope/vim-repeat" },
	})

	-- Completions
	--
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("rafamadriz/friendly-snippets")
	use({
		"L3MON4D3/LuaSnip",
		after = "friendly-snippets",
		wants = "friendly-snippets",
		config = function()
			local luasnip = require("luasnip")
			local options = {
				history = true,
				updateevents = "TextChanged,TextChangedI",
			}
			luasnip.config.set_config(options)
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	})

	use({
		"saadparwaiz1/cmp_luasnip",
		after = "LuaSnip",
	})
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.nvim_cmp")
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if Packer_bootstrap then
		require("packer").sync()
	end
end)
