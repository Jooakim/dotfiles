local function lspSymbol(name, icon)
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", "")
lspSymbol("Info", "")
lspSymbol("Hint", "")
lspSymbol("Warn", "")

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level)
	if msg:match("exit code") then
		return
	end
	if log_level == vim.log.levels.ERROR then
		vim.api.nvim_err_writeln(msg)
	else
		vim.api.nvim_echo({ { msg } }, true, {})
	end
end

-- credits to @Malace : https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- This is modified version of the above snippet
vim.lsp.buf.rename = {
	float = function()
		local currName = vim.fn.expand("<cword>") .. " "

		local win = require("plenary.popup").create(currName, {
			title = "Renamer",
			style = "minimal",
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			relative = "cursor",
			borderhighlight = "RenamerBorder",
			titlehighlight = "RenamerTitle",
			focusable = true,
			width = 25,
			height = 1,
			line = "cursor+2",
			col = "cursor-1",
		})

		local map_opts = { noremap = true, silent = true }

		vim.cmd("normal w")
		vim.cmd("startinsert")

		vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
		vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)

		vim.api.nvim_buf_set_keymap(
			0,
			"i",
			"<CR>",
			"<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
			map_opts
		)

		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<CR>",
			"<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
			map_opts
		)
	end,

	apply = function(curr, win)
		local newName = vim.trim(vim.fn.getline("."))
		vim.api.nvim_win_close(win, true)

		if #newName > 0 and newName ~= curr then
			local params = vim.lsp.util.make_position_params()
			params.newName = newName

			vim.lsp.buf_request(0, "textDocument/rename", params)
		end
	end,
}
