local utils = require "u.utils"
local cmds = {
    Ls = "buffers",
    Map = { "keymaps", { modes = { "n", "i", "c", "x", "t" } } },
    Au = "autocommands",
    Op = "vim_options",
    Com = "commands",
}

vim.iter(pairs(cmds)):each(
    function(key, value)
        vim.api.nvim_create_user_command(key, function()
                local b = require "telescope.builtin"
                local fn = type(value) == 'string' and b[value] or b[value[1]]
                local opts = type(value) == 'table' and value[2] or {}
                fn(opts)
            end,
            {}
        )
    end
)

vim.api.nvim_create_user_command("Cap", function(data)
    local ret = vim.api.nvim_exec2(data.args, { output = true })
    local bufnr = vim.api.nvim_create_buf(false, true)
    utils.buf.replace(bufnr, ret.output)
    utils.buf.set_opt(bufnr, "modifiable", false)
    utils.buf.set_opt(bufnr, "modified", false)
    utils.buf.set_opt(bufnr, "readonly", true)
    vim.api.nvim_win_set_buf(0, bufnr)
end, {
    complete = "command",
    nargs = "+",
})
