local main = "lspconfig"

-- setup lsp for language
local setup = function(lsp)
    local cap = require('cmp_nvim_lsp').default_capabilities()
    lsp.lua_ls.setup {
        on_init = function(client)
            -- ~/.config/nvim
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME }
                }
            })
        end,
        settings = { Lua = {} },
        capabilities = cap,
    }

    lsp.tsserver.setup {
        capabilities = cap,
    }

    lsp.gopls.setup {
    }

    lsp.pyright.setup {
        capabilities = cap,
    }

    lsp.ccls.setup {
        capabilities = cap,
    }

end

return {
    "neovim/nvim-lspconfig",
    main = main,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    event = 'VeryLazy',
    config = function()
        local lsp = require(main)
        setup(lsp)
    end,
}
