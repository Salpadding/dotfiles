return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local cap = require("cmp_nvim_lsp").default_capabilities()

    -- 1) shared defaults for all servers
    vim.lsp.config("*", {
      capabilities = cap,
    })

    -- 2) per-server configs (new API)
    local servers = { "lua_ls", "pyright", "ts_ls", "gopls", "ccls", "ruby_lsp", "jdtls" }
    for _, name in ipairs(servers) do
      vim.lsp.config(name, require("projects.lsp." .. name))
    end

    -- 3) enable (auto-start on matching filetypes & root)
    vim.lsp.enable(servers)
  end,
}
