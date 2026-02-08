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

---Scroll bind two windows together
---@param hashes_win integer Commits hashes window
---@param original_win integer Original window that is split off from
local function scroll_bind_windows_together(hashes_win, original_win)
    vim.api.nvim_win_set_option(original_win, "scrollbind", true)
    vim.api.nvim_win_set_option(hashes_win, "scrollbind", true)
end

local function highlight_all_targeted_lines(lines) -- NOTE: emmylua needed
    --[[ for _, id in ipairs(highlighted_matches) do
        vim.fn.matchdelete(id)
    end
    highlighted_matches = {} ]]
    -- NOTE: clear in separate function? return the ids for now?

    for _, line_num in ipairs(lines) do
        vim.fn.matchadd("CursorLine", "\\%" .. line_num .. "l")
        -- local id = vim.fn.matchadd("CursorLine", "\\%" .. line_num .. "l")
        -- table.insert(highlighted_matches, id)
    end
end

-- NOTE: apply_to_both_windows? = so can do function (like highlihting) I want to do to both

---Displays all of a file's lines' commit hashes
M.files_commit_hashes = function()
    local file_path = utils.current_file_path()
    local blame = blame_command.BlameCommand:new()
    local hashes = blame:commit_hashes_file(file_path)

    local original_window = vim.api.nvim_get_current_win()

    local hashes_buf = generate_hashes_buf_with_text(hashes)
    local hashes_window = render_hashes_win(hashes_buf, #hashes)
    set_hashes_win_and_buf_properties(hashes_window, hashes_buf)
    trigger_hashes_win_name_render(hashes_window, original_window)
    scroll_bind_windows_together(hashes_window, original_window)
    -- NOTE: need to start accounting for moving the cursor next
    -- just going off hash of first line for now
    -- and turning off when hashes_win closes
    local first_line_hash = hashes[1]
    local line_numbers_with_hash = {}
    for idx, hash in ipairs(hashes) do
        if hash == first_line_hash then
            table.insert(line_numbers_with_hash, idx)
        end
    end
    local line_numbers = line_numbers_with_hash
    highlight_all_targeted_lines(line_numbers)
end

return M
