local ok, telescope = pcall(require, "telescope")
if not ok then
    print("telescope not installed")
    return
end

telescope.load_extension('vim_bookmarks')
local actions = require "telescope.actions"

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default,
            }
        }
    }
})

local gerrit = function(opts)
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local handle = io.popen('git review -l -r origin')
    local action_state = require "telescope.actions.state"
    local result = handle:read("*a")
    handle:close()

    local reviews = {}
    local i = 1
    if result:find('^No') == nil then
        for s in result:gmatch("[^\r\n]+") do
            if s:find('^Found') == nil then
                reviews[i] = s
                i = i + 1
            end
        end
    end
    pickers.new(opts, {
        prompt_title = "gerrit reviews",
        finder = finders.new_table {
            results = reviews
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection ~= nil then
                    local change = string.match(selection[1], '%d*')
                    os.execute('git review -d ' .. change .. ' -r origin')
                    local ok, _ = pcall(require, "nvim-tree")
                    if ok then
                        vim.cmd("NvimTreeRefresh")
                    end
                end
            end)
            return true
        end,
    }):find()
end

-- "pin" current working directory when find files
local cwd = vim.fn.getcwd()

function TSMP(s)
    local tb = require('telescope.builtin')
    local tt = require('telescope.themes')
    if s == '-p' then
        tb.find_files(tt.get_dropdown({
            cwd = cwd,
            previewer = false
        }))
    end

    if s == '-P' then
        tb.find_files(
            tt.get_dropdown({
                cwd = cwd,
                previewer = false,
                no_ignore = true,
                hidden = true
            }
            )
        )
    end

    if s == "-f" then
        tb.live_grep({ layout_config = { width = 0.99 } })
    end

    if s == "-F" then
        tb.live_grep(
            {
                layout_config = { width = 0.99 },
                additional_args = function() return { "--no-ignore", "--hidden" } end
            }
        )
    end

    if s == "gv" then
        gerrit(tt.get_dropdown({ previewer = false }))
    end

    if s == "gm" then
        vim.cmd[[Telescope vim_bookmarks all]]
    end

    if s == "mm" then
        vim.cmd[[BookmarkToggle]]
    end
end

local opts = { noremap = true, silent = true }
local mp = vim.api.nvim_set_keymap

local keys = {
    "<leader>p", "<leader>P", "<leader>f", "<leader>F", "gv", "gm", "mm"
}

for _, k in pairs(keys) do
    local a = k:gsub("<leader>", "-")
    mp("n", k, string.format("<cmd>lua TSMP('%s')<cr>", a), opts)
end


