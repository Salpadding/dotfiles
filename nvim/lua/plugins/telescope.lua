local function setup()
    local telescope = require "telescope"
    local telescope_builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'
    local actions = require "telescope.actions"

    if not telescope or not telescope_builtin then
        return
    end

    -- telescope not distinguish between input and normal mode
    telescope.setup {
        defaults = {
            mappings = {
                i = {
                    -- tab select
                    ["<Tab>"] = actions.select_default,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                }
            },
        }
    }

    local keys = {
        { "<leader>p", function()
            telescope_builtin.find_files(themes.get_dropdown({
                cwd = ".",
                previewer = false
            }))
        end, "查找源文件 不包括 .gitignore 中忽略的文件" },
        {
            "<leader>P", function()
            telescope_builtin.find_files(themes.get_dropdown {
                cwd = ".",
                previewer = false,
                no_ignore = true,
                hidden = true,
            })
        end, "查找源文件 包括 .gitignore中忽略的文件"
        },
        {
            "<leader>f", function()
            telescope_builtin.live_grep { layout_config = { width = 0.99 } }
        end, "项目中查找文本 跳过.gitignore 中忽略的文件"
        },

        {
            "<leader>F", function()
            telescope_builtin.live_grep { layout_config = { width = 0.99 },
                additional_args = function()
                    return { "--no-ignore", "--hidden" }
                end
            }
        end, "项目中查找文本 包括.gitignore 中忽略的文件"
        },
    }

    local map = function(item)
        vim.keymap.set('n', item[1], item[2], { noremap = true, desc = item[3] })
    end

    vim.iter(keys):each(map)


    local helpers = require("u.helper")
    vim.keymap.set('n', 'gh', helpers.display_helper, { noremap = true, desc = "自定义帮助菜单" })
end


return {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = setup
}
