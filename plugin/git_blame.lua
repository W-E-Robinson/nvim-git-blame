vim.api.nvim_create_user_command("GitBlame", function()
    require("git_blame").blame()
end, {})
