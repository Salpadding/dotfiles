local utils = require("u.utils")
local defaults = require "u.defaults"

-- auto save when buffer modified
local auto_save = {
    debounce = defaults.auto_save.debounce,
    -- debounce for buffer
    buffers = {},

    callback = function(self, data)
        local buftype = utils.buf.get_opt(data.buf, "buftype")
        --- Abort autosave for special or excluded buffers.
        -- preventing autosave logic from running on non-standard buffers (e.g. terminals,
        -- help pages, prompts, or other plugin-defined buffer types).
        if utils.bool(buftype) then return end
        --- Guard clause: skips further auto-save logic when the current buffer has no valid name.
        --- returns early to avoid operating on transient or unnamed buffers.
        --- vim.api.nvim_buf_get_name returns the buffer's name as a string.
        --- It will return an empty string ("") if the buffer has no name
        if not utils.bool(vim.api.nvim_buf_get_name(data.buf)) then return end
        self.buffers[data.buf] = os.time()
    end,

    timer = function(self)
        local body = function(bufnr, last)
            --- Buffers can become invalid if they are deleted, unloaded, or otherwise no longer exist in the editor.
            if not utils.buf.is_valid(bufnr) then
                self.buffers[bufnr] = nil
                return
            end
            if not utils.buf.get_opt(bufnr, "modified") then
                -- Use checktime instead of :e - only reloads if file changed on disk
                vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
                self.buffers[bufnr] = nil  -- Remove from tracking since not modified
                return
            end
            if last ~= nil and os.time() - last > (self.debounce / 1000) then
                self.buffers[bufnr] = nil
                utils.buf.save(bufnr)
            end
        end
        for bufnr, last in pairs(self.buffers) do
            body(bufnr, last)
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
