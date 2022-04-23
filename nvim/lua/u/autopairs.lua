local ok, ap = pcall(require, "nvim-autopairs")

if not ok then print("autopairs not installed"); return end

local ok, cmp = pcall(require, "cmp")

if not ok then print("cmp not installed"); return end

ap.setup({
    -- check treesitter
    check_ts = true,
    ts_config = {
        lua = { 'string', "source" }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
    },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
