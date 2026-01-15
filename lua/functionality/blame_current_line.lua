local utils = require("utils.module")
local rendering = require("rendering.module")
local blame_command = require("git_commands.blame_command")
local show_command = require("git_commands.show_command")

local M = {}

M.blame_current_line = function()
    local current_window = vim.api.nvim_get_current_win()
    local current_row = vim.api.nvim_win_get_cursor(current_window)[1]
    local file_path = utils.current_file_path()

    local blame = blame_command.BlameCommand:new()
    local hash = blame:blame_current_line(file_path, current_row)

    local show = show_command.ShowCommand:new(hash)
    local show_stdout = show:commit_stdout_for_hash()

    local lines = utils.split_into_lines(show_stdout)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    rendering.display_buf_text_central_pop_up(buf, #lines)
end

return M
