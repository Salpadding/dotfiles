local utils = require "u.utils"
local a = require "plenary.async"

local helpers = {
    { "dap", "关闭dap", function()
        print("close dap")
    end }
}


local M = {
    helpers = helpers
}

M.display_helper = function()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require "telescope.config".values
    local action_state = require "telescope.actions.state"
    local themes = require('telescope.themes')
    local actions = require "telescope.actions"

    -- 长度最大的组的名称 用于调整显示菜单的大小
    local longest = vim.iter(M.helpers):fold(
        '', function(acc, value)
            return #value[1] > #acc and value[1] or acc
        end
    )


    pickers.new(themes.get_dropdown {
        previewer = false,
        layout_config = {
            height = math.min(#M.helpers + 8, vim.o.lines - 8)
        }
    }, {
        prompt_title = "帮助",
        finder = finders.new_table {
            results = M.helpers,
            entry_maker = function(entry)
                local pad = #longest - #entry[1]
                local txt = entry[1] .. ': ' .. string.rep(' ', pad) .. entry[2]
                return {
                    value = entry,
                    display = txt,
                    ordinal = txt,
                }
            end,
        },
        sorter = conf.generic_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection == nil then
                    return
                end

                selection.value[3]()
            end)
            return true
        end,
    }
    ):find()
end


return M




