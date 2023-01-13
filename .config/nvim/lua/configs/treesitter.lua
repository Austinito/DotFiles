return require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "python", "scala" },
    highlight = {
        enable = true,
        disable = {},
    },
    playground = {
        ensure_installed = "maintained",
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
}
