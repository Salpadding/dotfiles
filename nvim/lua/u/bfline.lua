local ok, bf = pcall(require, "bufferline")

if not ok then
    print("bufferline not installed")
    return
end

bf.setup({
    options = {
        offsets = { { filetype = "NvimTree", text = "", text_align = "center" } },
    }
})
