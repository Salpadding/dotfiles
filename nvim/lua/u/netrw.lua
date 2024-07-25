local defaults = require "u.defaults"
local utils = require "u.utils"


local function disable_net_rw()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

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

if defaults.options.nvim_tree then
    disable_net_rw()
else
    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 2
    vim.g.netrw_banner = 0

    vim.cmd [[
nn <leader>e :Lexplore<CR>
]]
end
