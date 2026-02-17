local blame_current_line_module = require("functionality.blame_current_line")
local files_commit_hashes_module = require("functionality.files_commit_hashes")
local utils = require("utils.module")

local config = {}

local M = {}

M.config = config

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.blame_current_line = function()
    utils.plugin_functionality_error_handler_wrapper(
        blame_current_line_module.blame_current_line
    )
end

M.files_commit_hashes = function()
    utils.plugin_functionality_error_handler_wrapper(
        files_commit_hashes_module.files_commit_hashes
    )
end

return M
