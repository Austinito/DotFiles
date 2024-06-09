-- Set the colors
vim.cmd("highlight StatusBarColor guifg=#EBDBB2 guibg=#665C54")
vim.cmd("highlight link StatusError DiagnosticError")
vim.cmd("highlight link StatusWarn DiagnosticWarn")
vim.cmd("highlight GitStatus guifg=#F0F0F0 guibg=#8EC07C gui=bold")
vim.cmd("highlight MetalsStatus guifg=#111111 guibg=#CC241D")
vim.cmd("highlight CodeiumStatus guifg=#FFFFFF guibg=#B16286 gui=bold")
vim.cmd("highlight FileInfo guifg=#0F0F0F guibg=#F0F0F0 gui=bold")

-- set global status line
vim.opt.laststatus = 3

local EmptyString = ""
--local EndBuffer = " "
--local EndBuffer = " "
--local EndBuffer = " "
--local EndBuffer = " "
local EndBuffer = " "

local function get_branch()
    local name = vim.api.nvim_call_function("FugitiveHead", {})
    if name and name ~= EmptyString then
        return "  " .. name .. " "
    else
        return EmptyString
    end
end

local function get_git_stats()
    -- Call `git diff --shortstat`
    local stats = vim.api.nvim_call_function("system", { "git diff --shortstat" })
    if string.match(stats, "^%d+%D+%d+%D+%d+") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+(%d+)%D+", "(+%2, -%3)")
    elseif string.match(stats, "^%d+%D+%d+ insertion") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+", "(+%2)")
    elseif string.match(stats, "^%d+%D+%d+ deletion") then
        stats = string.gsub(stats, "(%d+)%D+(%d+)%D+", "(-%2)")
    else
        stats = EmptyString
    end
    return stats
end

local function get_git_info()
    local branchInfo = get_branch()
    if branchInfo ~= EmptyString then
        local gitStats = get_git_stats()
        if gitStats ~= EmptyString then
            return branchInfo .. gitStats
        else
            return branchInfo
        end
    else
        return EmptyString
    end
end

local function get_modified()
    local isModified = vim.opt.modified:get()
    if isModified then
        return " "
    else
        return EmptyString
    end
end

local function get_readonly()
    local isReadOnly = vim.opt.readonly:get()
    if isReadOnly then
        return ""
    else
        return EmptyString
    end
end

local function err_count(severity)
    local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { severity = severity })
    if not next(diags) then
        return EmptyString
    else
        return " " .. #diags .. " "
    end
end

local function metals_status()
    local status = vim.g["metals_status"]
    if status and status ~= EmptyString then
        return " : " .. status .. " "
    else
        return EmptyString
    end
end

--This will produce a 3 char long string:
-- - '3/8' - third suggestion out of 8
-- - '0' - Codeium returned no suggestions
-- - '*' - waiting for suggestions
local function codium_status()
    local status = vim.api.nvim_call_function("codeium#GetStatusString", {})
    if status == EmptyString then
        return EmptyString
    else
        return " :" .. status .. " "
    end
end

-- Creates a merge between the two highlights
local function separate_highlights(hl_name_1, hl_name_2)
    local hl_1 = vim.api.nvim_get_hl(0, { name = hl_name_1 })
    local hl_2 = vim.api.nvim_get_hl(0, { name = hl_name_2 })

    local name = hl_name_1 .. hl_name_2
    local highlight_cmd = "highlight " .. name .. " guibg=#" .. string.format("%x", hl_2["bg"]) .. " guifg=#" .. string.format("%x", hl_1["bg"])
    vim.cmd(highlight_cmd)

    return "%#" .. name .. "#" .. EndBuffer .. "%#" .. hl_name_2 .. "#"
end

-- TODO: polish this up
-- Refreshing way too much
-- We should store the highlights, and not recreate them on every redraw
-- git stats broken?
function Austinito_custom_status_line()
    local statusLine = "";
    local codeium_info = codium_status()
    local metals_info = metals_status()
    statusLine = statusLine .. "%#GitStatus#" .. get_git_info()
    statusLine = statusLine .. separate_highlights("GitStatus", "FileInfo")
    statusLine = statusLine .. " %t " .. get_readonly() .. get_modified() ..
                    separate_highlights("FileInfo", "StatusBarColor") .. "%="

    if codeium_info and codeium_info ~= EmptyString then
        statusLine = statusLine .. separate_highlights("StatusBarColor", "CodeiumStatus") .. codium_status()
    end

    if metals_info and metals_info ~= EmptyString then
        if codeium_info and codeium_info ~= EmptyString then
            statusLine = statusLine .. separate_highlights("CodeiumStatus", "MetalsStatus") .. metals_status()
        else
            statusLine = statusLine .. separate_highlights("StatusBarColor", "MetalsStatus") .. metals_status()
        end
         statusLine = statusLine .. separate_highlights("MetalsStatus", "StatusBarColor") .. "%=%l, %c %p%%%"
    else
        statusLine = statusLine .. separate_highlights("CodeiumStatus", "StatusBarColor") .. "%=:%l :%c %p%%%"
    end


    return statusLine
end

vim.opt.statusline = "%!luaeval('Austinito_custom_status_line()')"
