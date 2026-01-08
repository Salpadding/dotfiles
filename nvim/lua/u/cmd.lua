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

-- Lua function to jump to a file and line number
local function jump_to_file_and_line()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cWORD>")

    -- Match the pattern `filename:linenumber`
    local filename, linenumber = string.match(word, "([^:]+):(%d+)")

    if filename and linenumber then
        -- Convert the line number to a number
        linenumber = tonumber(linenumber)

        -- Open the file and jump to the line number
        vim.cmd("edit " .. filename)
        vim.cmd(tostring(linenumber))
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-]>", true, false, true), "n", true)
    end
end

-- Create a custom Neovim command
vim.api.nvim_set_keymap('n', '<C-]>', '', { noremap = true, silent = true, callback = jump_to_file_and_line })

