local utils = require("utils.module")
local base_command = require("git_commands.base_command")

local M = {}

local BlameCommand = setmetatable({}, { __index = base_command.BaseCommand })
BlameCommand.__index = BlameCommand

function BlameCommand:new()
    return base_command.BaseCommand.new(self, { 'git', 'blame' })
end

function BlameCommand:blame_current_line(file_path, row)
    self:append(file_path)
    self:append("-L")
    self:append(string.format("%d,+1", row))
    self:execute()

    local hash, metadata, content = utils.strip_new_lines_from_string(self.stdout):match("^(%S+)%s+%((.-)%)%s+(.*)$")
    if not utils.is_line_full_history_available(hash) then
        hash = utils.remove_leading_caret_from_string(hash)
    end
    return hash, metadata, content
end

M.BlameCommand = BlameCommand

return M
