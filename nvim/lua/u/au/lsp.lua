local utils = require "u.utils"

local telescope_builtin = function()
    return require("telescope.builtin")
end

local defaults = require("u.defaults")

local lsp_format = function()
    local bufnr = vim.fn.bufnr('%')

    --- Replace the contents of the target buffer with the given string
    --- while preserving the user's current
    --- cursor line and column.
    local function replace(str)
        local ln = vim.fn.line('.')
        local col = vim.fn.col('.')
        utils.buf.replace(bufnr, str)
        vim.fn.cursor(ln, col)
    end

    -- 如果当前路径有.prettierrc 就用 prettier 格式化
    if vim.iter(defaults.prettier.ft):any(
            function(val) return vim.bo.filetype == val end
        ) and vim.uv.fs_stat(".prettierrc")
    then
        local lines = vim.fn.getline(1, '$')
        local joined = vim.iter(lines):join('\n')

        local obj = vim.system({ 'prettier', '--stdin-filepath', vim.fn.expand('%') },
            { stdin = joined, text = true }
        ):wait()

        if obj.stdout == joined then
            print('already formatted')
            return
        end
        if utils.bool(obj.stdout) then
            replace(obj.stdout)
        end
        return
    end

    vim.lsp.buf.format()
end

local keys = {
    { "gr", function()
        telescope_builtin().lsp_references { includeDeclaration = false, layout_config = { width = 0.99 } }
    end, "查找引用" },
    { "gd", function()
        telescope_builtin().lsp_definitions { layout_config = { width = 0.99 } }
    end, "跳转到定义" },
    { "<C-]>", function()
        telescope_builtin().lsp_definitions { layout_config = { width = 0.99 } }
    end, "跳转到定义" },
    { "gt", function()
        telescope_builtin().lsp_type_definitions()
    end, "跳转到类型定义" },
    { "gi", function()
        telescope_builtin().lsp_implementations { layout_config = { width = 0.99 } }
    end, "跳转到实现" },
    { "gL", function()
        print("ls diagnostics")
        telescope_builtin().diagnostics { bufnr = 0, layout_config = { width = 0.99 } }
    end, "显示所有报错" },
    { "=", lsp_format, "格式化" },
    { "K", function()
        vim.lsp.buf.hover()
    end, "函数类型提示" },
    { "gn", function()
        vim.lsp.buf.rename()
    end, "重命名标识符" },
    { "gl", function()
        vim.diagnostic.open_float { border = "rounded" }
    end, "显示当前行报错" },
    { "ga", function()
        vim.lsp.buf.code_action()
    end, "lsp code action" },
}



local attach = function(client, bufnr)
    vim.iter(keys):each(function(item)
        vim.keymap.set('n', item[1], item[2], { noremap = true, desc = item[3], buffer = bufnr })
    end)
end


vim.api.nvim_create_autocmd({ "LspAttach" }, {
    callback = function(data)
        attach(nil, data.buf)
    end
})
