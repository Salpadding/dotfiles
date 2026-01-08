local group = vim.api.nvim_create_augroup("FocusIndicator", { clear = true })

local dim_color = "#1a1a1a"

vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
        vim.g.focus_lost = true
        vim.opt.cursorline = false
        vim.cmd("hi Normal guibg=" .. dim_color)
        vim.cmd("hi NormalNC guibg=" .. dim_color)
    end,
})

vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
        vim.g.focus_lost = false
        vim.opt.cursorline = true
        vim.cmd("hi Normal guibg=NONE")
        vim.cmd("hi NormalNC guibg=NONE")
    end,
})
