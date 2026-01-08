local defaults = require "u.defaults"
local utils = require "u.utils"

-- netrw is disabled early in init.lua when nvim_tree is enabled
-- This file only sets up netrw config when not using nvim-tree

if not defaults.options.nvim_tree then
    vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = function(data)
            if utils.buf.get_opt(data.buf, "filetype") ~= "netrw" then return end
            vim.cmd [[
nn <buffer> <C-l> <C-w>l
nmap <buffer> l v
nmap <buffer> d <Del>
]]
        end
    })

    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 2
    vim.g.netrw_banner = 0

    vim.cmd [[
nn <leader>e :Lexplore<CR>
]]
end
