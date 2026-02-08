local utils = require("utils.module")
local blame_command = require("git_commands.blame_command")

local M = {}

---Generates the hashes buf using the input table of commmit hashs
---@param hashes string[] hashes to generate the buf from
---@return integer
local function generate_hashes_buf_with_text(hashes)
    local hashes_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(hashes_buf, 0, -1, false, hashes)
    return hashes_buf
end

---Renders the hashes window of correct height using the hashes buf
---@param hashes_buf integer the hashes buf
---@param hashes_length integer the hashes table length
---@return integer
local function render_hashes_win(hashes_buf, hashes_length)
    return vim.api.nvim_open_win(hashes_buf, false, {
        split = "left",
        width = 1, -- nvim_buf_set_name sets the width
        height = hashes_length,
        style = "minimal",
    })
end

---Sets properties of the hashes window and buf beyond those set upon initial rendering/creation
---@param hashes_win integer the hashes window
local function set_hashes_win_and_buf_properties(hashes_win, hashes_buf)
    vim.api.nvim_buf_set_name(hashes_buf, "Blame")

    vim.api.nvim_win_set_option(hashes_win, "number", false)
    vim.api.nvim_win_set_option(hashes_win, "relativenumber", false)
    vim.api.nvim_win_set_option(hashes_win, "cursorline", false)

    -- Hashes window can be closed with just q in normal mode
    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(hashes_win) then
            vim.api.nvim_win_close(hashes_win, true)
        end
        if vim.api.nvim_buf_is_valid(hashes_buf) then
            vim.api.nvim_buf_delete(hashes_buf, { force = true })
        end
    end, { buffer = hashes_buf, silent = true })
end

---Triggers the hashes window title, does not appear until focused
---@param hashes_win integer Commits hashes window
local function trigger_hashes_win_name_render(hashes_win)
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(hashes_win)
    vim.api.nvim_set_current_win(current_win)
end

---Displays all of a file's lines' commit hashes
M.files_commit_hashes = function()
    local file_path = utils.current_file_path()
    local blame = blame_command.BlameCommand:new()
    local hashes = blame:commit_hashes_file(file_path)

    local hashes_buf = generate_hashes_buf_with_text(hashes)
    local hashes_window = render_hashes_win(hashes_buf, #hashes)
    set_hashes_win_and_buf_properties(hashes_window, hashes_buf)
    trigger_hashes_win_name_render(hashes_window)
end

return M
