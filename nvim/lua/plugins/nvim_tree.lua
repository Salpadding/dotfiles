local main = "nvim-tree"
local defaults = require "u.defaults"

local M = {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    main = main,
    event = "VeryLazy",
    config = function(_, opts)
        local api = require("nvim-tree.api")
        require(main).setup(opts)
        vim.keymap.set('n', '<leader>e', function() api.tree.toggle { path = "." } end,
            { noremap = true, desc = "开启关闭 nvim-tree" })
    end,
    enabled = defaults.options.nvim_tree,
    opts = {
        sync_root_with_cwd = true,
        hijack_cursor = true,
        on_attach = function(bufnr)
            local api = require "nvim-tree.api"
            -- 仅在 nvimtree 所在的 buffer 生效
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
            vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
            vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
            vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        end,
        filters = {
            -- 不隐藏 .git 等 .开头的文件
            dotfiles = false,
            -- 不隐藏 .gitignore 里面的文件
            git_ignored = false,
        },
        renderer = {
            group_empty = true,
        },
        actions = {
            open_file = {
                resize_window = false
            },
            change_dir = {
                -- enable = false,
            }
        }
    }
}

return M
