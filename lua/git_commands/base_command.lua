local utils = require("utils.module")

local M = {}

---Class to extend upon for building git command functionality
---@class BaseCommand
---@field command string[]
---@field code integer|nil
---@field signal integer|nil
---@field stdout string|nil
---@field stderr string|nil
local BaseCommand = {}
BaseCommand.__index = BaseCommand

---Constructor for git base command class
---@generic T:BaseCommand
---@param self T
---@param cmd string[]
---@return T
function BaseCommand:new(cmd)
    return setmetatable({
        command = cmd,
        code = nil,
        signal = nil,
        stdout = nil,
        stderr = nil,
    }, self)
end

---Appends an arg onto the base git command constructed
---@param arg string git arg to be appended
function BaseCommand:append(arg)
    table.insert(self.command, arg)
end

---Executes the git command and populates code, signal, stdout and stderr. If
---the stderr contains git command error information, will error this code out
---as table to be handled by protected call at plugin top level functionality call.
function BaseCommand:execute()
    local execution_result = vim.system(self.command, { text = true }):wait()
    self.code = execution_result.code
    self.signal = execution_result.signal
    self.stdout = execution_result.stdout
    self.stderr = execution_result.stderr

    if self.stderr ~= "" then
        error({
            string.format("command - %s", table.concat(self.command, " ")),
            string.format(
                "error - %s",
                utils.strip_new_lines_from_string(self.stderr)
            ),
        })
    end
end

M.BaseCommand = BaseCommand

return M
