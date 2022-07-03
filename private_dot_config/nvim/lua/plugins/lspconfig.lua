local present, lspconfig = pcall(require, "lspconfig")

if not present then
	return
end

local M = {}
local utils = require("lspconfig/util")
local path = utils.path

require("plugins.lsp_handlers")

-- Borders for LspInfo winodw
local win = require("lspconfig.ui.windows")
local _default_opts = win.default_opts

win.default_opts = function(options)
	local opts = _default_opts(options)
	opts.border = "single"
	return opts
end

M.on_attach = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local function get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	-- Find and use virtualenv in workspace directory.
	local match = vim.fn.glob(path.join(workspace, ".venv"))
	if match ~= "" then
		local venv = vim.fn.trim(vim.fn.system("cat " .. match))
		local env_path = path.join("/home/joakim/.virtualenvs", venv, "bin/python")
		return env_path
	end

	-- Find and use virtualenv via poetry in workspace directory.
	match = vim.fn.glob(path.join(workspace, "poetry.lock"))
	if match ~= "" then
		local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
		return path.join(venv, "bin", "python")
	end
end

M.setup_lsp = function(attach, capabilities)
	local opts = {
		on_attach = attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}

	-- lspconfig.jdtls.setup(opts)
	lspconfig.jsonls.setup(opts)
	lspconfig.rust_analyzer.setup(opts)
	lspconfig.sumneko_lua.setup({
		on_attach = M.on_attach,
		capabilities = capabilities,

		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	})
	lspconfig.tsserver.setup(opts)
	lspconfig.svelte.setup(opts)

	opts.root_dir = vim.loop.cwd
	opts.on_init = function(client)
		client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
	end
	lspconfig.pyright.setup(opts)
end

M.setup_lsp(M.on_attach, capabilities)

return M
