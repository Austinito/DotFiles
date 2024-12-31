local M = {}

local dap = require("dap")
local dapui = require('dapui')

local disconnect_and_close = function()
    dap.disconnect()
    dapui.close()
end

-- dap hotkeys
local setup_hotkeys = function()
    -- Bind keys for DAP
    vim.keymap.set('n', '<leader>dc', dap.continue)
    vim.keymap.set('n', '<leader>dr', dap.repl.toggle)
    vim.keymap.set('n', '<leader>dt', dapui.toggle)
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>dso', dap.step_over)
    vim.keymap.set('n', '<leader>dsi', dap.step_into)
    vim.keymap.set('n', '<leader>dl', dap.run_last)
    vim.keymap.set('n', '<leader>dq', disconnect_and_close)
end

-- dap ui
local setup_ui = function()
    dapui.setup()
end

-- dap configs
M.setup = function()
    dap.configurations.scala = {
        {
            type = 'scala',
            request = 'attach',
            name = 'Remote Jetty Debug - K8s DEV',
            hostName = 'argos-server.dev.topgolf.io',
            port = 9999,
            buildTarget = 'root'
        },
        {
            type = 'scala',
            request = 'attach',
            name = 'Remote Jetty Debug',
            hostName = 'localhost',
            port = 9999,
            buildTarget = 'root'
        },
        {
            type = "scala",
            request = "launch",
            name = "Run or Test Target",
            metals = {
                runType = "runOrTestFile",
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
                runType = "testTarget",
            },
        },
    }
    setup_ui()
    setup_hotkeys()
end

return M
