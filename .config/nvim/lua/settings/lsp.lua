local M = {}
local functions = require "settings.functions"
local map = functions.map

M.setup = function()
    local lsp_config = require('lspconfig')
    -- add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    --    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })
    local on_attach = function(_, bufnr)
        -- LSP agnostic mappings
        map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
        map("n", "<C-k>", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
        map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
        map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
        map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
        map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
        map("n", "<leader><space>", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
        map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
        map("n", "<leader>f", [[<cmd>lua vim.lsp.buf.format({ async = true })<CR>]])
        map("v", "<leader>f", [[<cmd>lua vim.lsp.buf.format()<CR>]])

        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end

    -- METALS CONFIG ----------------------------------------------------------
    Metals_config = require("metals").bare_config()

    Metals_config.settings = {
        serverProperties = {
            "-Xms8G",
            "-Xmx12G",
        },
        ammoniteJvmProperties = { "-Xmx1G" },
        showImplicitArguments = true,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
        }
    }
    Metals_config.init_options.statusBarProvider = "on"
    Metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    Metals_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Metals mappings
        map("v", "K", [[<Esc><cmd>lua require("metals").type_of_range()<CR>]])
        map("n", "<leader>ws", [[<cmd>lua require("metals").hover_worksheet({ border = "single" })<CR>]])
        map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
        map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
        map("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])

        -- A lot of the servers I use won't support document_highlight or codelens,
        -- so we juse use them in Metals
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

    -- SUMNEKO LUA CONFIG -----------------------------------------------------
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    lsp_config.sumneko_lua.setup {
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim', 'string', 'pairs', 'ipairs', 'print', 'table', 'next' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
        capabilities = capabilities,
    }

    lsp_config.java_language_server.setup {
        cmd = { 'java-language-server' }
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
    local servers = { 'pyright', 'java_language_server' }
    for _, server in ipairs(servers) do
        local config = make_config()
        if server_configs[server] then config = vim.tbl_extend('error', config, server_configs[server]) end
        lsp_config[server].setup(config)
    end

end

return M
