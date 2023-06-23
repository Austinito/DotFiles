local M = {}

M.setup = function ()
    local cmp = require("cmp")
    cmp.setup({
        sources = {
            { name = "nvim_lsp", priority = 10 },
            { name = "buffer" },
            { name = "vsnip" }
        },
        snippet = {
            expand = function (args)
                require('luasnip').lsp_expand(args.body)
            end
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
    })
end

return M
