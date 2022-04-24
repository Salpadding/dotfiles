local ok, tree = pcall(require, 'nvim-tree')

vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "",
        ignored = "◌",
    },
    folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
    },
}

if not ok then
    print("nvim-tree not installed")
    return
end

local custom = function(opts)
    return {
        open_on_setup = true,
        open_on_setup_file = true,
        open_on_tab = true,
        hijack_cursor = true,
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        git = {
            enable = true,
            ignore = false,
        },
        view = {
            width = 20,
            mappings = {
                list = {
                    { key = { "l", "<CR>", "o" }, action = "edit" },
                    { key = "h", action = "close_node" },
                },
            },
        },
        actions = {
            change_dir = {
                enable = false
            },
            open_file = {
                resize_window = false
            }
        }
    }
end

tree.setup(custom({}))
