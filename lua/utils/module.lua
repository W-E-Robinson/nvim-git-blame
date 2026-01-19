local M = {}

function M.strip_new_lines_from_string(str)
    return (string.gsub(str, "\n", ""))
end

function M.remove_leading_caret_from_string(str)
    return str:gsub("^%^(.*)", "%1")
end

function M.current_file_path()
    -- argument of 0 gets current buffer
    return vim.api.nvim_buf_get_name(0)
end

function M.is_line_full_history_available(commit_hash) -- NOTE: add warning if so
    return string.find(commit_hash, "%^") == nil
end

function M.split_into_lines(str)
    local t = {}
    for line in str:gmatch("([^\n]*)\n?") do
        table.insert(t, line)
    end
    return t
end

function M.is_change_not_committed_yet(commit_hash)
    return string.sub(commit_hash, 1, 8) == "00000000"
end

return M
