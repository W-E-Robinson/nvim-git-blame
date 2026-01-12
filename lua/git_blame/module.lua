local utils = require("utils.module")
local command = require("command.module")

local M = {}

M.blame_current_line = function()
    local current_window = vim.api.nvim_get_current_win()
    local current_row = vim.api.nvim_win_get_cursor(current_window)[1]
    local file_path = utils.current_file_path()

    local blame = command.BlameCommand:new()
    blame:apply_file_path(file_path)
    blame:blame_current_line(current_row)
    local blame_command_result = blame:execute()

    -- messy get hash incoming
    local messy_first_part = blame_command_result.stdout:match("^(%S+)")
    local less_messy = utils.remove_leading_caret_from_string(messy_first_part)
    local show = command.ShowCommand:new(less_messy)
    show:suppress_diff()
    show:format('medium')
    local show_command_result = show:execute()

    -- handle below all the same/moduler?
    if show_command_result.code ~= 0 then
        utils.display_error_central_pop_up(blame_command_result.code, blame_command_result.signal,
            blame_command_result.stderr)
    else
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "Git be Infoing:",
            utils.strip_new_lines_from_string(show_command_result.stdout),
        })

        utils.display_buf_text_central_pop_up(buf)
    end
end

return M
