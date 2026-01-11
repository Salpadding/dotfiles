local defaults = require "u.defaults"
local utils = require "u.utils"

-- Disable netrw early if using nvim-tree (must be before any plugins load)
if defaults.options.nvim_tree then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

-- configure clipboard (OSC 52 for both copy and paste)
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- global options
vim.cmd.source(
    vim.fs.joinpath(
        vim.fn.stdpath("config"),
        "opts.vim"
    )
)

require "u.lazy"

vim.api.nvim_set_keymap("n", "q", "", {
    noremap = true,
    callback = function()
        if utils.buf.get_opt(0, "buftype") == "terminal" then
            vim.fn.feedkeys('i', 'n')
            return
        end
        vim.fn.feedkeys('q', 'n')
    end
})

vim.iter({ "n", "t" }):each(
    function(mode)
        vim.iter({ "h", "j", "k", "l", "c" }):each(function(key)
            if mode == "t" and key == "c" then return end
            vim.api.nvim_set_keymap(mode, string.format("<C-%s>", key), "",
                { noremap = true, callback = utils.fp.bind(utils.tmux.smart_wincmd, key) })
        end)
    end
)




-- autocommands
require "u.au"

-- custom commands
require "u.cmd"
require "u.netrw"
