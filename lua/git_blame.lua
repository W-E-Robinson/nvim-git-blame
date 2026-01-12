local module = require("git_blame.module")

local config = {}

local M = {}

M.config = config

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.blame_current_line = function()
    return module.blame_current_line()
end

return M
