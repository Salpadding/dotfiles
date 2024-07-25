local utils = require "u.utils"
local telescope = function()
    return {
        pickers = require 'telescope.pickers',
        finders = require 'telescope.finders',
        actions = require 'telescope.actions',
        action_state = require 'telescope.actions.state',
        conf = require('telescope.config').values,
        themes = require('telescope.themes')
    }
end


-- tabnr -> pwd
local tab_cwd = {}
local tab_buf = {}

tab_cwd[utils.tab.cur()] = vim.fn.getcwd()
tab_buf[utils.tab.cur()] = vim.api.nvim_list_bufs()


vim.api.nvim_create_autocmd({ "BufNew" }, {
    callback = function(data)
        tab_buf[utils.tab.cur()] = tab_buf[utils.tab.cur()] or {}
        tab_buf[utils.tab.cur()][data.buf] = true
    end
})

local tab_ls = function()
    local parse = function(i, line)
        local vals = vim.fn.split(vim.fn.trim(line))
        return { tonumber(vals[1]), vals[2], vals[3], vim.fn.trim(line), i }
    end


    local out = vim.api.nvim_exec2("ls", { output = true })

    local bufs = vim.iter(ipairs(vim.fn.split(out.output, '[\r\n]\\+'))):map(parse):filter(
        function(x)
            return utils.bool(tab_buf[utils.tab.cur()][x[1]])
        end
    ):totable()


    local cur = utils.buf.cur()
    local t = telescope()
    table.sort(bufs, function(x, y)
        if x[1] == cur then return true end
        if y[1] == cur then return false end
        return x[5] < y[5]
    end)

    t.pickers
        .new(t.themes.get_dropdown {
            previewer = false,
            layout_config = {
                height = math.min(#bufs + 8, vim.o.lines - 8)
            }
        }, {
            prompt_title = 'Buffers',
            finder = t.finders.new_table {
                results = bufs,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[4],
                        ordinal = entry[4],
                    }
                end,
            },
            sorter = t.conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map)
                t.actions.select_default:replace(function()
                    t.actions.close(prompt_bufnr)
                    local selection = t.action_state.get_selected_entry()
                    vim.cmd(string.format("buffer %d", selection.value[1]))
                end)
                return true
            end,
        })
        :find()
end


vim.api.nvim_create_autocmd({ "TabNewEntered" }, {
    callback = function()
        tab_cwd[utils.tab.cur()] = vim.fn.getcwd()
    end
})

vim.api.nvim_create_autocmd({ "TabClosed" }, {
    callback = function(data)
        local tab = tonumber(data.file)
        local _ = utils.bool(tab) and table.remove(tab_cwd, tab)
    end
})

local list_tabs = function()
    local t = telescope()
    local cur = utils.tab.cur()

    local tabs = vim.iter(vim.api.nvim_list_tabpages()):map(function(tab)
        local cwd = vim.fn.fnamemodify(tab_cwd[tab], ':t')
        return { tab, cwd }
    end):totable()

    table.sort(tabs, function(x, y)
        local xi = x[1] == cur and 0 or cur
        local yi = y[1] == cur and 0 or cur
        return xi < yi
    end)
    t.pickers
        .new(t.themes.get_dropdown {
            previewer = false,
            layout_config = {
                height = math.min(#tabs + 8, vim.o.lines - 8)
            }
        }, {
            prompt_title = 'Tabs',
            finder = t.finders.new_table {
                results = tabs,
                entry_maker = function(entry)
                    local entry_string = string.format("%3d %s", entry[1], entry[2])

                    return {
                        value = entry,
                        display = entry_string,
                        ordinal = entry[2],
                    }
                end,
            },
            sorter = t.conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map)
                t.actions.select_default:replace(function()
                    t.actions.close(prompt_bufnr)
                    local selection = t.action_state.get_selected_entry()
                    vim.api.nvim_set_current_tabpage(selection.value[1])
                end)
                return true
            end,
        })
        :find()
end



vim.api.nvim_create_user_command('Tabs', list_tabs, {})
