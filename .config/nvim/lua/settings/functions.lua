local M = {};

M.toggle_quickfix = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd('cclose')
            return
        end
    end
    vim.cmd('copen')
end


M.clear_registers = function()
    vim.cmd [[let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
    ]]
end

M.load_configs = function(path)
    local config_path = vim.fn.stdpath('config') .. '/lua/' .. path
    for _, file in ipairs(vim.fn.readdir(config_path)) do
        if file:sub(-4) == '.lua' then
            local module = path .. '.' .. file:sub(1, -5)
            local loaded_module = require(module)
            if type(loaded_module) == 'table' and loaded_module.setup then
                loaded_module.setup()
            end
        end
    end
end

return M
