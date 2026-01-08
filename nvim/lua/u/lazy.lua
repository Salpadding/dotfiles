local utils = require "u.utils"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- install lazy, a plugin manager, if not installed
if not utils.bool(vim.uv.fs_stat(lazypath)) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

-- add lazy to neovim runtime path, so we can require "lazy"
vim.opt.rtp:prepend(lazypath)

-- let lazy load plugins from disk
local lazy = require("lazy")
lazy.setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json"
})
