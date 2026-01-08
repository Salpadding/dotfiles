local utils = require("u.utils")
local a = require "plenary.async"
local defaults = require "u.defaults"
local fp = utils.fp
local bind = utils.fp.bind

local M = {}

M.smart_shift = function(bufnr)
    local filetype = utils.buf.get_opt(bufnr, "filetype")

    if not vim.iter(defaults.prettier.ft):any(
            bind(fp.eq, filetype)
        ) then
        return false
    end

    if not utils.fs.is_file(".prettierrc") then return false end

    local data = utils.fs.read_file(".prettierrc")
    if not data then return true end
    local prettierrc = vim.json.decode(data)
    local tabs = prettierrc["tabWidth"]
    if type(tabs) ~= 'number' or tabs <= 0 then
        return true
    end

    vim.schedule(function()
        -- when modifiy vim options
        utils.buf.set_opt(bufnr, "tabstop", tabs)
        utils.buf.set_opt(bufnr, "shiftwidth", tabs)
    end)
    return true
end


-- detect filetype and .pretterrrc then set shiftwidth
vim.api.nvim_create_autocmd({ 'FileType' }, {
    callback = function(data)
        a.run(bind(M.smart_shift, data.buf), utils.fp.noop)
    end
})

return M
