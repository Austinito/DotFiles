local function toggle_quickfix()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd('cclose')
            return
        end
    end
    vim.cmd('copen')
end


local function clear_registers()
    vim.cmd[[let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
    ]]
end

local function load_lua_files(path)
    local files = vim.fn.globpath(path, '*.lua', true, false)
    for _, file in ipairs(files) do
        local ok, err = pcall(dofile, file)
        if not ok then
            print("Error loading " .. file .. ": " .. err)
        end
    end
end

return {
    toggle_quickfix = toggle_quickfix,
    clear_registers = clear_registers,
    load_lua_files = load_lua_files,
}
