return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
        local languages = {
            "c", "lua", "rust", "go", "make", "yaml",
            "solidity", "bash", "cpp", "javascript",
            "typescript", "vue", "json", "vim", "python", "toml", "tsx", "xml",
            "html", "css", "vimdoc", "printf", "java", "ruby"
        }

        -- Install parsers
        for _, lang in ipairs(languages) do
            pcall(function()
                vim.treesitter.language.add(lang)
            end)
        end

        -- Enable treesitter highlighting
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Folding
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.opt.foldlevel = 99

        pcall(function()
            vim.treesitter.query.set("printf", "highlights", "(format) @keyword")
        end)
    end
}
