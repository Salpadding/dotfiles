return {
    {
        "nvim-neotest/nvim-nio", lazy = true,
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        event = "VeryLazy",
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup {}

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set('n', "mb", dap.toggle_breakpoint, { noremap = true, desc = "开启/关闭 断点" })
        end
    }
}
