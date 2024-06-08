-- Set the colors
vim.cmd("hi! StatusLine guifg=#5C6370 guibg=#282C34")
vim.cmd("hi! link StatusError DiagnosticError")
vim.cmd("hi! link StatusWarn DiagnosticWarn")
vim.cmd("highlight GitStatus guifg=#111111 guibg=#8EC07C gui=bold")
vim.cmd("highlight MetalsStatus guifg=#111111 guibg=#CC241D")
vim.cmd("highlight CodeiumStatus guifg=#FFFFFF guibg=#B16286 gui=bold")
vim.cmd("highlight FileInfo guifg=#0F0F0F guibg=#F0F0F0 gui=bold")

-- set global status line
vim.opt.laststatus = 3
vim.opt.statusline = "%!luaeval('Austinito_custom_status_line()')"

local function get_branch()
    local name = vim.api.nvim_call_function("FugitiveHead", {})
    if name and name ~= "" then
        return "  (" .. name .. ") "
    else
        return ""
    end
end

local function get_git_stats()
    -- Call `git diff --shortstat`
    local stats = vim.api.nvim_call_function("system", { "git diff --shortstat" })
    -- make sure stats is only one-two lines
    if string.match(stats, "^%d+%D+%d+%D+%d+") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+(%d+)%D+", "(+%2, -%3)")
    elseif string.match(stats, "^%d+%D+%d+ insertion") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+", "(+%2)")
    elseif string.match(stats, "^%d+%D+%d+ deletion") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+", "(-%2)")
    else
        stats = ""
    end
    return stats
end

local function get_git_info()
    local branchInfo = get_branch()
    if branchInfo ~= "" then
        local gitStats = get_git_stats()
        if gitStats ~= "" then
            return branchInfo .. gitStats
        else
            return branchInfo
        end
    else
        return ""
    end
end

local function get_modified()
    local isModified = vim.opt.modified:get()
    if isModified then
        return " "
    else
        return ""
    end
end

local function get_readonly()
    local isReadOnly = vim.opt.readonly:get()
    if isReadOnly then
        return ""
    else
        return ""
    end
end

local function err_count(severity)
    local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { severity = severity })
    if not next(diags) then
        return ""
    else
        return " " .. #diags .. " "
    end
end

local function metals_status()
    local status = vim.g["metals_status"]
    if status and status ~= "" then
        return " : " .. status .. " "
    else
        return ""
    end
end

--This will produce a 3 char long string:
-- - '3/8' - third suggestion out of 8
-- - '0' - Codeium returned no suggestions
-- - '*' - waiting for suggestions
local function codium_status()
    local status = vim.api.nvim_call_function("codeium#GetStatusString", {})
    if status == "" then
        return ""
    else
        return " :" .. status .. " "
    end
end

function Austinito_custom_status_line()
    return table.concat({
        "%#GitStatus#",
        get_git_info(),
        "%#FileInfo#",
        " %t ", -- file name
        get_readonly(),
        get_modified(),
        "%#StatusLine#",
        "%#StatusError#",
        err_count("Error"),
        "%#StatusWarn#",
        err_count("Warn"),
        "%#StatusLine#",
        "%=",
        "%#CodeiumStatus#",
        codium_status(),
        "%#MetalsStatus#",
        metals_status(),
        "%#StatusLine#",
        "%=",
        "%l, ",
        "%c ",
        "%"
    })
end
