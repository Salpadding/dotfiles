local opts = { noremap = true, silent = true }

-- Shorten function name
local mp = vim.api.nvim_set_keymap

--Remap space as leader key
mp("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- always display file full path
mp("n", "<C-g>", "1<C-g>", opts)

-- Better window navigation
mp("n", "<C-h>", "<cmd>:TmuxNavigateLeft<cr>", opts)
mp("n", "<C-j>", "<cmd>:TmuxNavigateDown<cr>", opts)
mp("n", "<C-k>", "<cmd>:TmuxNavigateUp<cr>", opts)
mp("n", "<C-l>", "<cmd>:TmuxNavigateRight<cr>", opts)
mp("n", "<C-c>", "<C-w>c", opts)

-- Resize with arrows
mp("n", "<C-Up>", ":resize -2<cr>", opts)
mp("n", "<C-Down>", ":resize +2<cr>", opts)
mp("n", "<C-Left>", ":vertical resize -2<cr>", opts)
mp("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- open explorer by <leader> + e
mp("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Visual --
-- Stay in indent mode
mp("n", ">", ">>", opts)
mp("n", "<", "<<", opts)
mp("v", "<", "<gv", opts)
mp("v", ">", ">gv", opts)

-- avoid overriding of register
-- use leader + d to override register
mp("v", "p", '"_dp', opts)
mp("v", "P", '"_dP', opts)

mp("n", "<leader><Space>", "<cmd>b#<cr>", opts)
mp("n", "<leader>br", "<cmd>NvimTreeToggle<cr><cmd>bufdo! e<cr><cmd>NvimTreeToggle<cr>", opts)
mp("n", "<leader>bd", "<cmd>Bwipeout<cr>", opts)
