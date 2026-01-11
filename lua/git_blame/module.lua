local M = {}

M.show_info = function()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "Git Blame Info",
        "----------------",
        "This is a simple popup example.",
        "You can add more info here."
    })

    local width = 40
    local height = 6
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    })
end

vim.api.nvim_create_user_command("GitBlame", M.show_info, {})

vim.keymap.set("n", "<leader>bl", M.show_info, { noremap = true, silent = true })

return M
