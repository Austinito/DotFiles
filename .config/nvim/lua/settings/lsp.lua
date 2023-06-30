local M = {}

M.setup = function()
    local lsp_config = require('lspconfig')

    -- add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })
    local on_attach = function(_, bufnr)
        -- LSP agnostic mappings
        vim.keymap.set("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
        vim.keymap.set("n", "<C-k>", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
        vim.keymap.set("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
        vim.keymap.set("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
        vim.keymap.set("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
        vim.keymap.set("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
        vim.keymap.set("n", "<leader><space>", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
        vim.keymap.set("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
        vim.keymap.set("n", "<leader>f", [[<cmd>lua vim.lsp.buf.format({ async = true })<CR>]])
        vim.keymap.set("v", "<leader>f", [[<cmd>lua vim.lsp.buf.format()<CR>]])
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end

    -- METALS CONFIG ----------------------------------------------------------
    Metals_config = require("metals").bare_config()
    Metals_config.settings = {
        serverProperties = {
            "-Xms8G",
            "-Xmx12G"
        },
        ammoniteJvmProperties = { "-Xmx1G" },
        showImplicitArguments = true,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
        },
        scalafmtConfigPath = ".scalafmt.conf",
    }
    Metals_config.init_options.statusBarProvider = "on"
    Metals_config.capabilities = capabilities
    Metals_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Metals mappings
        vim.keymap.set("n", "<leader>ws", [[<cmd>lua require("metals").hover_worksheet({ border = "single" })<CR>]])
        vim.keymap.set("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
        vim.keymap.set("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
        vim.keymap.set("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])
        -- A lot of the servers I use won't support document_highlight or codelens,
        -- so we use use them in Metals
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = lsp_group,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = lsp_group,
        })
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            callback = vim.lsp.codelens.refresh,
            buffer = bufnr,
            group = lsp_group,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dap-repl" },
            callback = function()
                require("dap.ext.autocompl").attach()
            end,
            group = lsp_group,
        })
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
            require("metals").initialize_or_attach(Metals_config)
        end,
        group = nvim_metals_group,
    })

    lsp_config.java_language_server.setup {
        cmd = { 'java-language-server' }
    }

    lsp_config.lua_ls.setup {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
        on_attach = on_attach,
    }

    local function make_config()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }
        return {
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
            on_attach = on_attach,
        }
    end

    local server_configs = {
        ['java_language_server'] = {
            cmd = { 'lang_server_mac.sh' }
        }

    }

    -- ALL OTHERS
    local servers = { 'pyright', 'java_language_server', 'tsserver', 'vuels' }
    for _, server in ipairs(servers) do
        local config = make_config()
        if server_configs[server] then config = vim.tbl_extend('error', config, server_configs[server]) end
        lsp_config[server].setup(config)
    end

end

return M
