local function setup_dap()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup dap-ui
    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.25 },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
            },
            {
                elements = {
                    { id = "repl", size = 0.5 },
                    { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
            },
        },
        floating = {
            max_height = nil,
            max_width = nil,
            border = "single",
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
    })

    -- Setup virtual text
    require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
    })

    -- Auto open dapui (auto-close disabled to keep UI open after session ends)
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    -- Uncomment below to re-enable auto-close:
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --     dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --     dapui.close()
    -- end

    -- Signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

    -- Keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<F5>", dap.continue, opts)
    vim.keymap.set("n", "<F10>", dap.step_over, opts)
    vim.keymap.set("n", "<F11>", dap.step_into, opts)
    vim.keymap.set("n", "<F12>", dap.step_out, opts)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
    vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, opts)
    vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, opts)
    vim.keymap.set("n", "<leader>dr", dap.repl.open, opts)
    vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, opts)
    vim.keymap.set("n", "<leader>dt", dap.terminate, opts)
    vim.keymap.set("n", "<leader>ds", function()
        dap.continue({ new = true })  -- Start new session, shows config picker
    end, opts)

    -- Debug adapters configuration

    -- Python (debugpy)
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "/usr/bin/python"
                end
            end,
        },
    }

    -- Node.js / JavaScript / TypeScript (pwa-node via vscode-js-debug)
    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}",
            },
        },
    }
    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
    }
    dap.configurations.typescript = dap.configurations.javascript

    -- Go (delve)
    dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
        },
    }
    dap.configurations.go = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
        },
        {
            type = "go",
            name = "Debug Package",
            request = "launch",
            program = "${workspaceFolder}",
        },
        {
            type = "go",
            name = "Debug Test",
            request = "launch",
            mode = "test",
            program = "${file}",
        },
    }

    -- C/C++/Rust (codelldb or lldb-vscode)
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            args = { "--port", "${port}" },
        },
    }
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- Java (via jdtls)
    -- Register Java adapter when jdtls attaches
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "jdtls" then
                -- Register the Java debug adapter
                dap.adapters.java = function(callback)
                    -- Request the debug adapter port from jdtls
                    client:request("workspace/executeCommand", {
                        command = "vscode.java.startDebugSession",
                    }, function(err, port)
                        if err then
                            vim.notify("Failed to start Java debug session: " .. vim.inspect(err), vim.log.levels.ERROR)
                            return
                        end
                        callback({
                            type = "server",
                            host = "127.0.0.1",
                            port = port,
                        })
                    end, args.buf)
                end

                -- Add Java-specific debug keymaps
                local opts = { buffer = args.buf, noremap = true, silent = true }
                vim.keymap.set("n", "<leader>dm", function()
                    client:request("workspace/executeCommand", {
                        command = "vscode.java.resolveMainClass",
                    }, function(err, result)
                        if err then
                            vim.notify("Failed to resolve main class: " .. vim.inspect(err), vim.log.levels.ERROR)
                            return
                        end
                        if result and #result > 0 then
                            vim.ui.select(result, {
                                prompt = "Select main class:",
                                format_item = function(item)
                                    return item.mainClass
                                end,
                            }, function(choice)
                                if choice then
                                    dap.run({
                                        type = "java",
                                        request = "launch",
                                        name = "Launch " .. choice.mainClass,
                                        mainClass = choice.mainClass,
                                        projectName = choice.projectName,
                                    })
                                end
                            end)
                        else
                            vim.notify("No main class found", vim.log.levels.WARN)
                        end
                    end, args.buf)
                end, opts)
            end
        end,
    })

    -- Load project-specific configurations from .dap/launch.lua
    -- The file should return a function that receives (dap, dapui) or a table of configurations
    local project_dap_file = vim.fn.getcwd() .. "/.dap/launch.lua"
    if vim.fn.filereadable(project_dap_file) == 1 then
        local ok, project_config = pcall(dofile, project_dap_file)
        if ok then
            if type(project_config) == "function" then
                -- Call the function with dap and dapui for full control
                project_config(dap, dapui)
            elseif type(project_config) == "table" then
                -- Merge configurations by filetype
                for filetype, configs in pairs(project_config) do
                    if dap.configurations[filetype] then
                        -- Append to existing configurations
                        for _, config in ipairs(configs) do
                            table.insert(dap.configurations[filetype], config)
                        end
                    else
                        -- Create new filetype configurations
                        dap.configurations[filetype] = configs
                    end
                end
            end
        else
            vim.notify("Error loading .dap/launch.lua: " .. tostring(project_config), vim.log.levels.WARN)
        end
    end
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
        config = setup_dap,
    },
    { "rcarriga/nvim-dap-ui", lazy = true },
    { "theHamsta/nvim-dap-virtual-text", lazy = true },
    { "nvim-neotest/nvim-nio", lazy = true },
}
