vim.api.nvim_create_user_command("BlameCurrentLine", function()
    require("git_blame").blame_current_line()
end, {})
