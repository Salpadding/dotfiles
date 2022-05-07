local options = {
    backup = false, -- disable backup file
    writebackup = false, -- if a file is being edited by another program (or was written to file
    -- while editing with another program), it is not allowed to be edited
    swapfile = false, -- disable swapfile

    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    smartcase = true, -- smart case, use \c or \C to override smart case
    pumheight = 24, -- Maximum number of items to show in the popup menu
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2, -- always show tabs
    smartindent = true, -- make indenting smarter again
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    termguicolors = true, -- set term gui colors (most terminals support this)
    timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true, -- enable persistent undo
    updatetime = 300, -- faster completion (4000ms default)

    expandtab = true, -- convert tabs to spaces
    shiftwidth = 4, -- the number of spaces inserted for each indentation
    tabstop = 4, -- insert 4 spaces for a tab

    cursorline = true, -- highlight the current line
    colorcolumn = "120", -- 右侧参考线 超过表示代码太长 建议换行

    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 2, -- set number column width to 2 {default 4}

    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    wrap = true, -- display lines as one long line
    background = "dark",

    scrolloff = 32,
}


for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Lua:
-- For dark theme
vim.g.vscode_style = "dark"
-- Enable transparent background
vim.g.vscode_transparent = 1
-- Enable italic comment
vim.g.vscode_italic_comment = 1
-- Disable nvim-tree background color
vim.g.vscode_disable_nvimtree_bg = true
-- vim bookmar settings
vim.g.bookmark_save_per_working_dir = 1
vim.g.bookmark_auto_save = 1
vim.g.bookmark_sign = ""
vim.g.tmux_navigator_no_mappings = 1
local ok, vscode = pcall(require, "vscode")

if ok then
    vim.cmd("colorscheme vscode")
end
