local M = {}

M.imap = function(tbl)
	vim.keymap.set("i", tbl[1], tbl[2])
end

M.nmap = function(tbl)
	vim.keymap.set("n", tbl[1], tbl[2])
end

M.vmap = function(tbl)
	vim.keymap.set("v", tbl[1], tbl[2])
end

return M
