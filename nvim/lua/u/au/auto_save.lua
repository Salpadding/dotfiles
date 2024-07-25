local utils = require("u.utils")
local a = require "plenary.async"
local defaults = require "u.defaults"

-- auto save when buffer modified
local auto_save = {
    debounce = defaults.auto_save.debounce,
    -- debounce for buffer
    buffers = {},

    callback = function(self, data)
        local buftype = utils.buf.get_opt(data.buf, "buftype")
        if utils.bool(buftype) then return end
        if not utils.bool(vim.api.nvim_buf_get_name(data.buf)) then return end
        self.buffers[data.buf] = os.time()
    end,

    timer = function(self)
        for bufnr, last in ipairs(self.buffers) do
            if not utils.buf.is_valid(bufnr) then
                table.remove(self.buffers, bufnr)
                goto continue
            end
            if last ~= nil and os.time() - (self.debounce / 1000) > last then
                self.buffers[bufnr] = nil
                print("Autosaved for " .. vim.fn.bufname(bufnr))
                utils.buf.save(bufnr)
            end
            ::continue::
        end
    end
}


vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = utils.fp.bind(auto_save.callback, auto_save),
    desc = "auto_save monitor",
})

vim.schedule(function()
    local timer = vim.uv.new_timer()
    local fn = utils.fp.bind(auto_save.timer, auto_save)
    timer:start(0, auto_save.debounce / 2, utils.fp.bind(vim.schedule, fn))
end)
