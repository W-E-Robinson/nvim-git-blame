vim.api.nvim_create_user_command("GitBlameCurrentLine", function()
    require("git_blame").blame_current_line()
end, {})
vim.keymap.set("n", "<leader>bcl", require("git_blame").blame_current_line, { noremap = true, silent = true })
