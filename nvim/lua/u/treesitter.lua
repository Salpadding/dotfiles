local ok, ts = pcall(require, "nvim-treesitter.configs")

if not ok then
    print("treesitter not installed")
    return
end

ts.setup({
    ensure_installed = {
        "c", "lua", "rust", "go", "make", "yaml",
        "solidity", "bash", "cpp", "javascript",
        "typescript", "vue", "json", "vim", "python", "toml"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "yaml" } },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil
    },
    autopairs = { enable = true },

    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#integrations
    context_commentstring = {
        enable = true,
        enable_autocmd = false
    }
})
