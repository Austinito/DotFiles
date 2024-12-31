local M = {}

M.on_attach = function(_, bufnr)
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
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {buf = bufnr})
end

M.setup = function()
    local lsp_config = require('lspconfig')

    -- add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()

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
        on_attach = M.on_attach,
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
            on_attach = M.on_attach,
        }
    end

    local server_configs = {
        -- java_language_server
        -- We need to use custom script to start the server
        ['chsarp_ls'] = {
            handlers = {
                ['textDocument/definition'] = require('csharpls_extended').handler
            }
        },
        ['clangd'] = {
            offsetEncoding = 'utf-16'
        },
        -- tsserver deprecated, is not ts_ls
        -- We want to overwrite the format capability to use prettier
        -- overwrite the on_attach function to use the one we defined, except for the
        -- formatting part... which will be handled by prettier
        ['ts_ls'] = {
            settings = {
                documentFormatting = false
            },
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
                vim.keymap.set("n", "<C-k>", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
                vim.keymap.set("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
                vim.keymap.set("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
                vim.keymap.set("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
                vim.keymap.set("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
                vim.keymap.set("n", "<leader><space>", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
                vim.keymap.set("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])

                vim.keymap.set("n", "<leader>f", [[<cmd>silent %!prettier --stdin-filepath %<CR>]])
                vim.keymap.set("v", "<leader>f", [[<cmd>echo "TODO: Support view formatting for prettier"<CR>]])
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end
        }
    }

    -- ALL OTHERS
    local servers = { 'pyright', 'jdtls', 'ts_ls', 'vuels', 'csharp_ls', 'clangd' }
    for _, server in ipairs(servers) do
        local config = make_config()
        if server_configs[server] then config = vim.tbl_extend('force', config, server_configs[server]) end
        lsp_config[server].setup(config)
    end
end

return M
