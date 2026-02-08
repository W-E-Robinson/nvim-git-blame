local utils = require("utils.module")
local base_command = require("git_commands.base_command")

local M = {}

---@class BlameCommand : BaseCommand
local BlameCommand = setmetatable({}, { __index = base_command.BaseCommand })
BlameCommand.__index = BlameCommand

---Create a new BlameCommand instance
---@return BlameCommand
function BlameCommand:new()
    return base_command.BaseCommand.new(self, { "git", "blame" })
end

---Returns formatted git blame information for a given line in a file
---@param file_path string Absolute file path
---@param row number line number to be blamed
---@return { hash: string, metadata: string, content: string }
function BlameCommand:blame_current_line(file_path, row)
    self:append(file_path)
    self:append("-L")
    self:append(string.format("%d,+1", row))
    self:execute()

    local hash, metadata, content = utils
        .strip_new_lines_from_string(self.stdout)
        :match("^(%S+)%s+%((.-)%)%s+(.*)$")
    if not utils.is_line_full_history_available(hash) then
        hash = utils.remove_leading_caret_from_string(hash)
    end
    return {
        hash = hash,
        metadata = metadata,
        content = content,
    }
end

---Returns commit hashes for every line for a provided file path
---@param file_path string Absolute file path
---@return string[] Commit hash strings for each line of the file
function BlameCommand:commit_hashes_file(file_path)
    self:append(file_path)
    -- Suppress the author name and timestamp from the output
    self:append("-s")
    self:execute()

    local blame_lines = utils.split_into_lines(self.stdout)
    local hashes = {}
    for _, line in pairs(blame_lines) do
        local hash = line:match("^(%S+)")
        table.insert(hashes, hash)
    end

    return hashes
end

M.BlameCommand = BlameCommand

return M
