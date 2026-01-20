local base_command = require("git_commands.base_command")

local M = {}

local ShowCommand = setmetatable({}, { __index = base_command.BaseCommand })
ShowCommand.__index = ShowCommand

function ShowCommand:new(hash)
    return base_command.BaseCommand.new(self, { "git", "show", hash })
end

function ShowCommand:suppress_diff()
    self:append("--no-patch")
end

function ShowCommand:format_output(format_option)
    self:append(string.format("--format=%s", format_option))
end

function ShowCommand:commit_stdout_for_hash()
    self:suppress_diff()
    self:format_output("medium")
    self:execute()

    return self.stdout
end

M.ShowCommand = ShowCommand

return M
