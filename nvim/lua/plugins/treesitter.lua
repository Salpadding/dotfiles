local main = "nvim-treesitter.configs"

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = main,
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            "c", "lua", "rust", "go", "make", "yaml",
            "solidity", "bash", "cpp", "javascript",
            "typescript", "vue", "json", "vim", "python", "toml", "tsx", "xml",
            "html", "css", "vimdoc", "printf", "java", "ruby"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
    config = function(_, opts)
        require(main).setup(opts)
        vim.cmd [[
            set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
            set foldlevel=99
            ]]
        vim.treesitter.query.set("printf", "highlights", "(format) @keyword")
    end
}
