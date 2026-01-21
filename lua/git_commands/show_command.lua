local base_command = require("git_commands.base_command")

local M = {}

---@class ShowCommand : BaseCommand
local ShowCommand = setmetatable({}, { __index = base_command.BaseCommand })
ShowCommand.__index = ShowCommand

---Create a new ShowCommand instance
---@param hash string commit_hash
---@return ShowCommand
function ShowCommand:new(hash)
    return base_command.BaseCommand.new(self, { "git", "show", hash })
end

---Appends '--no-patch' to the git command args
function ShowCommand:suppress_diff()
    self:append("--no-patch")
end

---Appends given format to the git command args
---@param format_option string the git format option
function ShowCommand:format_output(format_option)
    self:append(string.format("--format=%s", format_option))
end

---Executes and returns the stdout of the git show command
---@return string The stdout
function ShowCommand:commit_stdout_for_hash()
    self:suppress_diff()
    self:format_output("medium")
    self:execute()

    return self.stdout
end

M.ShowCommand = ShowCommand

return M
