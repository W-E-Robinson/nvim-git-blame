local CENTRAL_POP_UP_WIDTH_COLUMNS = 100
local CENTRAL_POP_UP_MAX_HEIGHT_ROWS = 25

local M = {}

---Displays a buf in a central pop up
---@param buf integer Buf to be displayed, buf contains a table of strings
---@param height number provided height required to display lines of buf
---@param title string title of the pop up
function M.display_buf_text_central_floating_pop_up(buf, height, title)
    local width = CENTRAL_POP_UP_WIDTH_COLUMNS

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height > CENTRAL_POP_UP_MAX_HEIGHT_ROWS
                and CENTRAL_POP_UP_MAX_HEIGHT_ROWS
            or height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = title,
        title_pos = "center",
    })

    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end, { buffer = buf, silent = true })
end

return M
