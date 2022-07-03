local ok, null_ls = pcall(require, "null-ls")

if not ok then
	return
end

local b = null_ls.builtins

local sources = {

	-- Python
	b.formatting.black,
	b.diagnostics.flake8,
	b.formatting.isort,

	-- Lua
	b.formatting.stylua,

	-- JSON/HTML/JS
	b.formatting.prettier,

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

	-- Rust
	b.formatting.rustfmt,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
