local blame_current_line_module = require("functionality.blame_current_line")

local config = {}

local M = {}

M.config = config

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.blame_current_line = function()
    return blame_current_line_module.blame_current_line()
end

return M
