local utils = require("utils.module")

local M = {}

M.blame_current_line = function()
    local current_window = vim.api.nvim_get_current_win()
    local current_row = vim.api.nvim_win_get_cursor(current_window)[1]

    local file_path = utils.current_file_path()
    local processResult = vim.system({ 'git', 'blame', file_path, '-L', string.format("%d,+1", current_row) },
        { text = true }):wait()

    if processResult.code ~= 0 then
        utils.display_error_central_pop_up(processResult.code, processResult.signal,
            processResult.stderr)
    else
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "Git Blame Info:",
            utils.strip_new_lines_from_string(processResult.stdout),
        })

        utils.display_buf_text_central_pop_up(buf)
    end
end

vim.api.nvim_create_user_command("GitBlameCurrentLine", M.blame_current_line, {})

-- <leader>BlameCurrentLine
vim.keymap.set("n", "<leader>bcl", M.blame_current_line, { noremap = true, silent = true })

return M
