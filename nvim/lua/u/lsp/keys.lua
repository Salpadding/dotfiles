-- keymaps
function LSPMP(s)
    local ok, tb = pcall(require, "telescope.builtin")
    if not ok then
        print("LSPMP: telescope not installed")
    end
    if s == "ga" then
        tb.lsp_code_actions()
    end
    if s == "gr" then
        tb.lsp_references(
            { includeDeclaration = false, layout_config = { width = 0.99 } }
        )
    end

    if s == "gC" then
        tb.git_bcommits({ layout_config = { width = 0.99 } })
    end

    if s == "gB" then
        tb.git_branches({ layout_config = { width = 0.99 } })
    end

    if s == "gd" then
        tb.lsp_definitions({ layout_config = { width = 0.99 } })
    end

    if s == "gt" then
        tb.lsp_type_definitions()
    end

    if s == "gi" then
        tb.lsp_implementations({ layout_config = { width = 0.99 } })
    end

    if s == "gL" then
        tb.diagnostics({ bufnr = 0, layout_config = { width = 0.99 } })
    end

    if s == "=" then
        vim.lsp.buf.formatting()
    end

    if s == "K" then
        vim.lsp.buf.hover()
    end
    if s == "gn" then
        vim.lsp.buf.rename()
    end

    if s == "gl" then
        vim.diagnostic.open_float({ border = "rounded" })
    end
end
