local ok, lsp = pcall(require, "lspconfig")
if not ok then
    print("lspconfig not installed")
    return
end

local ok, ins = pcall(require, "nvim-lsp-installer")

if not ok then
    print("lsp installer not installed")
    return
end

-- setup lsp diagnostic
require "u.lsp.signs"
-- export global keymaps
require "u.lsp.keys"

-- setup lsp installer, lazy load language server
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local mp = vim.api.nvim_buf_set_keymap
    local keys = {
        "gr", "gC", "gB", "gd", "gt",
        "gi", "gL", "K",
        "gn", "gl", "="
    }

    for _, k in ipairs(keys) do
        mp(bufnr, "n", k, string.format('<cmd>lua LSPMP([[%s]])<cr>', k), opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
              augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              augroup END
            ]],
            false
        )
    end
end

-- setup capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
else
    print("cmp_nvim_lsp not installed")
end


ins.on_server_ready(
    function(s)
        local ok, opts = pcall(require, "u.lsp.settings." .. s.name)
        if not ok then
            opts = {}
        end

        local fn = on_attach
        if opts.on_attach then
            local sub = opts.on_attach
            fn = function(c, b)
                sub(c, b)
                on_attach(c, b)
            end
        end
        opts.on_attach = fn
        opts.capabilities = capabilities
        s:setup(opts)
    end
)

-- setup null-ls
require "u.lsp.nl"
