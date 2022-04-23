local ok, gs = pcall(require, "gitsigns")

if not ok then
    print("gitsigns not installed")
    return
end

gs.setup({})
