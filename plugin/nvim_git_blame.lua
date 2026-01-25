vim.api.nvim_create_user_command("BlameCurrentLine", function()
    require("nvim_git_blame").blame_current_line()
end, {})
