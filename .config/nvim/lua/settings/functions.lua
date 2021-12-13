local function map(mode, key, value, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, key, value, options)
end

local function toggle_quickfix()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd('cclose')
            return
        end
    end
    vim.cmd('copen')
end

return {
    map = map,
    toggle_quickfix = toggle_quickfix
}
