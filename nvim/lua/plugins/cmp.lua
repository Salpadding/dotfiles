local utils = require "u.utils"
local deps = {
    "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "windwp/nvim-autopairs", "folke/lazydev.nvim"
}

local function setup()
    local cmp           = require("cmp")
    local luasnip       = require("luasnip")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    local function magic_enter(fallback)
        if not cmp or not cmp.get_selected_entry() then
            fallback()
            return
        end
        cmp.confirm()
    end

    local function magic_tab(fallback)
        if not cmp or not cmp.visible() then
            fallback()
            return
        end

        if cmp.get_selected_entry() then
            cmp.confirm()
            return
        end

        cmp.select_next_item()
    end

    local function magic_lf(fallback)
        if not cmp.visible() then
            cmp.complete()
            return
        end
        cmp.select_next_item()
    end

    local function scroll_page(page_size, direction)
        local entries = cmp.get_entries()
        if not entries or #entries == 0 then return end
        local current = cmp.get_selected_entry()
        local idx = 0
        for i, e in ipairs(entries) do
            if e == current then idx = i; break end
        end
        local remaining = direction > 0 and (#entries - idx) or (idx - 1)
        for _ = 1, math.min(page_size, remaining) do
            if direction > 0 then
                cmp.select_next_item()
            else
                cmp.select_prev_item()
            end
        end
    end

    local mapping = {
        -- 选择下一个
        ["<C-j>"] = cmp.mapping(magic_lf, { "i", "c" }),
        -- 选择上一个
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        -- 往上翻一页
        ['<C-b>'] = cmp.mapping(utils.fp.bind(scroll_page, 10,-1), { "i", "c" }),
        -- 往下翻一页
        ['<C-f>'] = cmp.mapping(utils.fp.bind(scroll_page, 10, 1), { "i", "c" }),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<CR>'] = cmp.mapping(magic_enter, { "i", "c" }),
        -- 类似 idea 的 tab
        ['<C-l>'] = cmp.mapping(magic_tab, { "i", "c" }),
        ['<Tab>'] = cmp.mapping(magic_tab, { "i", "c" })
    }

    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        sources = cmp.config.sources({
            { name = "lazydev" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer" },
        }),
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = mapping,
    }

    -- 常规模式下搜索也可以补全
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = {
            ["<Tab>"] = cmp.mapping.confirm(),
            ["<C-k>"] = mapping["<C-k>"],
            ["<C-j>"] = mapping["<C-j>"],
        },
        sources = cmp.config.sources({ { name = 'buffer' } })
    })

    -- 命令也可以补全
    cmp.setup.cmdline(':', {
        mapping = {
            ["<Tab>"] = cmp.mapping.confirm(),
            ["<C-k>"] = mapping["<C-k>"],
            ["<C-j>"] = mapping["<C-j>"],
        },
        sources = cmp.config.sources({ { name = 'path' }, { name = 'cmdline' } })
    })
end

local opts = {
    {
        "hrsh7th/nvim-cmp",
        dependencies = deps,
        event = "VeryLazy",
        config = setup,
    },
}

vim.iter(deps):map(function(item)
    return { item, lazy = true }
end):each(utils.fp.bind(table.insert, opts))

return opts
