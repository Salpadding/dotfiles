return {
    "Mofiqul/vscode.nvim",
    config = function()
        local main = require("vscode")
        main.setup {}
        vim.cmd "colorscheme vscode"
    end
}
