local M = {}

--  I need to strip the leading caret on commit hashes shorter name one

function M.strip_new_lines_from_string(str)
    return (string.gsub(str, "\n", ""))
end

function M.remove_leading_caret_from_string(str)
    -- wait wait, use at git blame first when possible!!
    return (string.gsub(str, "^", "", 1))
end

function M.display_buf_text_central_pop_up(buf)
    local width = 100
    local height = 20

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded"
    })
end

function M.current_file_path()
    -- argument of 0 gets current buffer
    return vim.api.nvim_buf_get_name(0)
end

function M.display_error_central_pop_up(code, signal, stderr)
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Git Blame Error Info:",
        "Code:",
        string.format("%d", code),
        "Signal:",
        string.format("%d", signal),
        "Std Error:",
        M.strip_new_lines_from_string(stderr),
    })

    M.display_buf_text_central_pop_up(buf)
end

return M
