require("telescope").setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { prompt_position = 'bottom' },
        file_ignore_patterns = {
            "^./worktrees/",
            "^./project/",
            "^./target/",
            "^./.metals/",
            "^./.bloop/"
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column"
        }
    }
})

require("telescope").load_extension("git_worktree")
