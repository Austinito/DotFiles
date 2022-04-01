local M = {}

M.setup = function()
    local lsp_config = require('lspconfig')
    -- add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
--    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    -- METALS CONFIG ----------------------------------------------------------
    Metals_config = require("metals").bare_config()

    Metals_config.settings = {
        serverProperties = {
            "-Xms8G",
            "-Xmx12G",
        },
        ammoniteJvmProperties = {"-Xmx1G"},
        showImplicitArguments = true,
        showInferredType = true,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
        }
    }
    Metals_config.init_options.statusBarProvider = "on"
    Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

--    Metals_config.on_attach = function (client, bufnr)
--        vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
--        vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
--        vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])
--    end

    -- SUMNEKO LUA CONFIG -----------------------------------------------------
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    local sumneko_binary_path = vim.fn.exepath('lua-language-server')
    local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

    lsp_config.sumneko_lua.setup {
--        cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
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
                    globals = {'vim'},
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
        cmd = {'java-language-server'}
    }

local on_attach = function(client, _)

    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_command [[au BufWritePre <buffer> lua vim.lsp.buf.formatting()]]
    elseif client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_command [[au BufWritePre <buffer> lua vim.lsp.buf.range_formatting()]]
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

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
    capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
    on_attach = on_attach,
  }
end

local server_configs = {
    ['java_language_server'] = {
        cmd = {'lang_server_mac.sh'}
    }

}

    -- ALL OTHERS
    local servers = {'pyright', 'java_language_server'}
    for _, server in ipairs(servers) do
        local config = make_config()
        if server_configs[server] then config = vim.tbl_extend('error', config, server_configs[server]) end
        lsp_config[server].setup(config)
    end

end

return M
