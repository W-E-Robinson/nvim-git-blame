local module = require("git_blame.module")

local config = {}

local M = {}

M.config = config

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.blame = function()
    return module.popup_current_line_git_blame_info()
end

return M
