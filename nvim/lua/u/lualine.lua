local ok, l = pcall(require, "lualine")

if not ok then
    print("lualine not installed")
    return
end

l.setup({
    options = {
        theme = "vscode"
    }
})
