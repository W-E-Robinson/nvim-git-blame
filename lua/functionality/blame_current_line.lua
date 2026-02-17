local utils = require("utils.module")
local rendering = require("rendering.module")
local blame_command = require("git_commands.blame_command")
local show_command = require("git_commands.show_command")

local M = {}

---Displays current line history information in central pop up
M.blame_current_line = function()
    local current_window = vim.api.nvim_get_current_win()
    local current_row = vim.api.nvim_win_get_cursor(current_window)[1]
    local file_path = utils.current_file_path()

    local blame = blame_command.BlameCommand:new()
    local hash = blame:blame_current_line(file_path, current_row).hash

    if utils.is_change_not_committed_yet(hash) then
        local not_committed_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(
            not_committed_buf,
            0,
            -1,
            false,
            { "Not committed yet..." }
        )
        rendering.display_buf_text_central_floating_pop_up(
            not_committed_buf,
            1,
            "Commit Information"
        )
        return
    end

    local show = show_command.ShowCommand:new(hash)
    local show_stdout = show:commit_stdout_for_hash()

    local lines = utils.split_into_lines(show_stdout)

    local commit_info_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(commit_info_buf, 0, -1, false, lines)

    rendering.display_buf_text_central_floating_pop_up(
        commit_info_buf,
        #lines,
        "Commit Information"
    )
end

return M
