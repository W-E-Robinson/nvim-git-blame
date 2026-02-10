local utils = require("utils.module")
local blame_command = require("git_commands.blame_command")

local M = {}

---Generates the hashes buf using the input table of commt hashes
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
---@param original_win integer Original window that is split off from
local function trigger_hashes_win_name_render(hashes_win, original_win)
    vim.api.nvim_set_current_win(hashes_win)
    vim.api.nvim_set_current_win(original_win)
end

---Scoll binds two windows together for when moving
---@param hashes_win integer Commits hashes window
---@param original_win integer Original window that is split off from
local function scroll_bind_two_windows_together(hashes_win, original_win)
    vim.api.nvim_win_set_option(original_win, "scrollbind", true)
    vim.api.nvim_win_set_option(hashes_win, "scrollbind", true)
end

---Returns the current row number of the cursor
---@param window integer window to get current cursor row from
---@return integer number row that the cursor is on
local function current_row(window)
    local cursor = vim.api.nvim_win_get_cursor(window)
    local row = cursor[1]
    return row
end

local namespace = vim.api.nvim_create_namespace("files_commit_hashes")

---Clears the namespace of a buf and re highlights new lines
---@param buf integer buf to have namespace cleared and rehighlighted
---@param lines integer[] lines to now be highlighted
local function clear_and_rehighlight_lines(buf, lines)
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)

    for _, line in ipairs(lines) do
        vim.api.nvim_buf_add_highlight(
            buf,
            namespace,
            "CursorLine",
            line - 1,
            0,
            -1
        )
    end
end

---Updates the highlighting of the windows due to new cursor line
---@param original_window integer original file window
---@param hashes_window integer hashes window of commits
---@param hashes string[] array of hashes for file lines
local function update_highlights_both_windows(
    original_window,
    hashes_window,
    hashes
)
    if
        not vim.api.nvim_win_is_valid(original_window)
        or not vim.api.nvim_win_is_valid(hashes_window)
    then
        return
    end

    local original_buf = vim.api.nvim_win_get_buf(original_window)
    local hashes_buf = vim.api.nvim_win_get_buf(hashes_window)

    local row = current_row(original_window)
    local row_hash = hashes[row]

    local same_hash_lines = {}
    for idx, hash in ipairs(hashes) do
        if hash == row_hash then
            table.insert(same_hash_lines, idx)
        end
    end

    clear_and_rehighlight_lines(original_buf, same_hash_lines)
    clear_and_rehighlight_lines(hashes_buf, same_hash_lines)
end

---Displays all of a file's lines' commit hashes
M.files_commit_hashes = function()
    -- Windows setup
    local original_window = vim.api.nvim_get_current_win()

    local file_path = utils.current_file_path()
    local blame = blame_command.BlameCommand:new()
    local hashes = blame:commit_hashes_file(file_path)

    local hashes_buf = generate_hashes_buf_with_text(hashes)
    local hashes_window = render_hashes_win(hashes_buf, #hashes)
    set_hashes_win_and_buf_properties(hashes_window, hashes_buf)
    trigger_hashes_win_name_render(hashes_window, original_window)

    scroll_bind_two_windows_together(hashes_window, original_window)

    -- Highlighting based on line function called from
    update_highlights_both_windows(original_window, hashes_window, hashes)

    -- Autocommands
    local group =
        vim.api.nvim_create_augroup("FileCommitHashes", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = group,
        callback = function()
            update_highlights_both_windows(
                original_window,
                hashes_window,
                hashes
            )
        end,
    })
end

return M
