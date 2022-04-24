local ok, cmp = pcall(require, "cmp")
if not ok then
    print("cmp not installed")
    return
end

local ok, ls = pcall(require, "luasnip")
if not ok then
    print("luasnip not installed")
    return
end

require("luasnip.loaders.from_vscode").lazy_load()

local icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

local mp = function(s)
    if s == "<C-k>" then
        return cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" })
    end
    if s == "<C-j>" then
        return cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" })
    end
    if s == "<C-b>" then
        local fn = function() for _ = 1, 16 do cmp.select_prev_item() end end
        return cmp.mapping(fn, { "i", "c" })
    end
    if s == "<C-f>" then
        local fn = function() for _ = 1, 16 do cmp.select_next_item() end end
        return cmp.mapping(fn, { "i", "c" })
    end
    if s == "<C-u>" then
        return cmp.mapping.scroll_docs(-4)
    end
    if s == "<C-d>" then
        return cmp.mapping.scroll_docs(4)
    end
    if s == "<Tab>" or s == "<C-l>" then
        local fn = function(fallback)
            if not cmp or not cmp.visible() then
                fallback()
                return
            end

            if cmp.get_active_entry() then
                cmp.confirm()
                return
            end

            cmp.select_next_item()
        end
        return cmp.mapping(fn, { "i", "c" })
    end
end

cmp.setup({
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end
    },
    preselect = cmp.PreselectMode.None,
    mapping = {
        ["<C-j>"] = mp("<C-j>"),
        ["<C-k>"] = mp("<C-k>"),
        ['<C-b>'] = mp("<C-b>"),
        ['<C-f>'] = mp("<C-f>"),
        ['<C-d>'] = mp("<C-d>"),
        ['<C-u>'] = mp("<C-u>"),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),

        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-l>'] = mp("<C-l>"),
        ["<Tab>"] = mp("<Tab>"),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "buffer" },
        { name = "path" },
    }),
    window = {
        -- display documentation after snippet
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        }
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(e, t)
            t.kind = icons[t.kind]
            t.menu = ({
                nvim_lsp = "[L]",
                nvim_lua = "[N]",
                luasnip = "[S]",
                buffer = "[B]",
                path = "[P]",
            })[e.source.name]
            return t
        end,
    },
})

cmp.setup.cmdline('/', {
    mapping = {
        ["<Tab>"] = cmp.mapping.confirm(),
        ["<C-k>"] = mp("<C-k>"),
        ["<C-j>"] = mp("<C-j>"),
    },
    sources = { { name = 'buffer' } }
}
)

cmp.setup.cmdline(':', {
    mapping = {
        ["<Tab>"] = cmp.mapping.confirm(),
        ["<C-k>"] = mp("<C-k>"),
        ["<C-j>"] = mp("<C-j>"),
    },
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})
