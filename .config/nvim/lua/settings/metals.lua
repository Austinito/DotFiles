local M = {}

-- dap configs
local setupDap = function ()
    local dap = require("dap")
    dap.configurations.scala = {
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
end

-- METALS CONFIG ----------------------------------------------------------
M.setup = function()
    local lsp = require('settings.lsp')
    local metals = require("metals")
    local metals_config = metals.bare_config()

    metals_config.settings = {
        serverProperties = {
            "-Xms8G",
            "-Xmx12G"
        },
        ammoniteJvmProperties = { "-Xmx1G" },
        enableSemanticHighlighting = false,
        showImplicitArguments = true,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
        },
        scalafmtConfigPath = ".scalafmt.conf",
        testUserInterface = "Test Explorer",
    }
    metals_config.init_options.statusBarProvider = "on"
    metals_config.capabilities =vim.lsp.protocol.make_client_capabilities()

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    metals_config.on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        -- dap support
        metals.setup_dap()
        -- Metals mappings
        vim.keymap.set("n", "<leader>ws", [[<cmd>lua require("metals").hover_worksheet({ border = "single" })<CR>]])
        vim.keymap.set("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
        vim.keymap.set("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
        vim.keymap.set("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])

        -- Bind keys for DAP
        vim.api.nvim_set_keymap('n', '<leader>dc', "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dr', "<Cmd>lua require'dap'.repl.toggle()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dt', "<Cmd>lua require'dapui'.toggle()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dso', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dsi', "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dl', "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true })

        -- Bind key for triggering code-lens
        vim.api.nvim_set_keymap('n', '<leader>cl', '<Cmd>lua vim.lsp.codelens.run()<CR>', { noremap = true, silent = true })

        -- A lot of the servers I use won't support document_highlight or codelens,
        -- so we use use them in Metals
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = nvim_metals_group,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = nvim_metals_group,
        })
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            callback = vim.lsp.codelens.refresh,
            buffer = bufnr,
            group = nvim_metals_group,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dap-repl" },
            callback = function()
                require("dap.ext.autocompl").attach()
            end,
            group = nvim_metals_group,
        })
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
            metals.initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
    })
end

return M
