local utils = require "u.utils"

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


-- global options
vim.cmd.source(
    vim.fs.joinpath(
        vim.fn.stdpath("config"),
        "opts.vim"
    )
)

-- override ftplugin defaults
-- PREFIX=/opt/homebrew/Cellar/neovim/0.10.0/share/nvim
-- such as $PREFIX/runtime/ftplugin, $PREFIX/runtime/indent, $PREFIX/runtime/syntax, $PREFIX/runtime/autoload

-- install lazy, a plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not utils.bool(vim.uv.fs_stat(lazypath)) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

-- add lazy to neovim runtime path, so we can require "lazy"
vim.opt.rtp:prepend(lazypath)

-- let lazy load plugins from disk
local lazy = require("lazy")
lazy.setup("plugins")

-- autocommands
require "u.au"

-- custom commands
require "u.cmd"
require "u.netrw"
