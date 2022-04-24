local ok, n = pcall(require, "neoscroll")

if not ok then
    print("neoscroll not installed")
    return
end

n.setup({
})
