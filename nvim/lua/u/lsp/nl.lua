local ok, nl = pcall(require, "null-ls")
if not ok then
    return
end

nl.setup({
    sources = {
        nl.builtins.formatting.gofmt,
    }
})
