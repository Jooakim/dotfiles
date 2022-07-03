local nmap = require("keymap").nmap

-- Telescope
nmap({ "<leader>ff", "<cmd>Telescope find_files<cr>" })
nmap({ "<leader>fg", "<cmd>Telescope live_grep<cr>" })
nmap({ "<leader>fb", "<cmd>Telescope buffers<cr>" })
nmap({ "<leader>fh", "<cmd>Telescope help_tags<cr>" })
nmap({ "<leader>fp", "<cmd>Telescope project<cr>" })
nmap({ "<leader>fr", "<cmd>Telescope resume<cr>" })
nmap({ "<leader>fw", "<cmd>Telescope live_grep<cr>" })
nmap({ "<leader>fs", "<cmd>Telescope grep_string<cr>" })
nmap({ "<C-n>", "<cmd>Telescope file_browser<cr>" })

-- Movement
nmap({ "<C-h>", "<C-w>h" })
nmap({ "<C-l>", "<C-w>l" })
nmap({ "<C-j>", "<C-w>j" })
nmap({ "<C-k>", "<C-w>k" })

-- Misc
nmap({ "<ESC>", "<cmd> noh <cr>" })

-- Create a Format function
vim.cmd([[command! Format lua vim.lsp.buf.formatting_sync()]])

-- LSP
nmap({ "gD", vim.lsp.buf.declaration })
nmap({ "gd", vim.lsp.buf.definition })
nmap({ "K", vim.lsp.buf.hover })
nmap({ "gi", vim.lsp.buf.implementation })
nmap({ "ge", vim.diagnostic.open_float })
nmap({ "gr", vim.lsp.buf.references })
nmap({ "<C-k>", vim.lsp.buf.signature_help })
nmap({ "<space>wa", vim.lsp.buf.add_workspace_folder })
nmap({ "<space>wr", vim.lsp.buf.remove_workspace_folder })
nmap({ "<space>D", vim.lsp.buf.type_definition })
nmap({ "<space>rn", vim.lsp.buf.rename })
nmap({ "<space>ca", vim.lsp.buf.code_action })
nmap({ "<space>fm", vim.lsp.buf.formatting })
