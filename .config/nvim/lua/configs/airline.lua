local cmd = vim.cmd

local function metals_status()
    return vim.g["metals_status"] or "<NOTHING>"
end

cmd [[let g:airline#extensions#branch#displayed_head_limit = 10]]
-- cmd [[let g:airline_section_b = '%-0.20{getcwd()}']]
cmd([[let g:airline_section_c = '%t | ]] .. metals_status() .. [[ | T123']])
