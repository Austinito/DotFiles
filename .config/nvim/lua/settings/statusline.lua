local function get_branch()
    local name = vim.api.nvim_call_function("FugitiveHead", {})
    if name and name ~= "" then
        return "  (" .. name .. ") "
    else
        return ""
    end
end

local function get_modified()
    local isModified = vim.opt.modified:get()
    if isModified then
        return "  "
    else
        return ""
    end
end

local function get_readonly()
    local isReadOnly = vim.opt.readonly:get()
    if isReadOnly then
        return "  "
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
    return vim.g["metals_status"] or ""
end

--This will produce a 3 char long string:
-- - '3/8' - third suggestion out of 8
-- - '0' - Codeium returned no suggestions
-- - '*' - waiting for suggestions
local function codium_status()
    return vim.api.nvim_call_function("codeium#GetStatusString", {})
end

function Austinito_custom_status_line()
    return table.concat({
        get_branch(),
        " %t ", -- file name
        get_readonly(),
        get_modified(),
        "%#StatusError#",
        err_count("Error"),
        "%#StatusWarn#",
        err_count("Warn"),
        "%#StatusLine#",
        "Metals: ",
        metals_status(),
        "%=",
        "Codeium: ",
        codium_status(),
        "%=",
        "%l, ",
        "%c ",
        "%"
    })
end
