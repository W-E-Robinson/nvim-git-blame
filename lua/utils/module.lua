local M = {}

---Removes new lines '\n' from a string
---@param str string The string to be stripped
---@return string
function M.strip_new_lines_from_string(str)
    return (string.gsub(str, "\n", ""))
end

---Removes preceding caret from a given string and returns
---@param str string The string to be modified
---@return string
function M.remove_leading_caret_from_string(str)
    return str:gsub("^%^(.*)", "%1")
end

---Returns absolute path of current file
---@return string
function M.current_file_path()
    -- argument of 0 gets current buffer
    return vim.api.nvim_buf_get_name(0)
end

---Determines if commit hash is preceded with a caret, indicating incomoplete history
---@param commit_hash string The commit hash
---@return boolean
function M.is_line_full_history_available(commit_hash)
    return string.find(commit_hash, "%^") == nil
end

---Splits a string on new lines, returning as a table
---@param str string The string containing new lines
---@return table string[]
function M.split_into_lines(str)
    local t = {}
    for line in str:gmatch("([^\n]*)\n?") do
        table.insert(t, line)
    end
    return t
end

local UNCOMMITTED_GIT_HASH = "00000000"

---Detects if a commit hash is part of an ongoing uncommitted change
---@param commit_hash string The commit hash
---@return boolean
function M.is_change_not_committed_yet(commit_hash)
    return string.sub(commit_hash, 1, 8) == UNCOMMITTED_GIT_HASH
end

return M
