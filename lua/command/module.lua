local M = {}

local Command = {}
Command.__index = Command

function Command:new(cmd)
    return setmetatable({
        command = { 'git', cmd },
    }, self)
end

function Command:append(option)
    table.insert(self.command, option)
end

function Command:execute()
    return vim.system(self.command, { text = true }):wait()
end


local BlameCommand = setmetatable({}, { __index = Command })
BlameCommand.__index = BlameCommand

function BlameCommand:new()
    local obj = Command.new(self, 'blame')
    return obj
end

function BlameCommand:apply_file_path(file_path)
    self:append(file_path)
end

function BlameCommand:blame_current_line(row)
    self:append("-L")
    self:append(string.format("%d,+1", row))
end

M.BlameCommand = BlameCommand


local ShowCommand = setmetatable({}, { __index = Command })
ShowCommand.__index = ShowCommand

function ShowCommand:new(hash)
    local obj = Command.new(self, 'show', hash)
    return obj
end

function ShowCommand:suppress_diff()
    self:append('--no-patch')
end

function ShowCommand:format(format_option)
    self:append(string.format("--format=%s", format_option))
end

M.ShowCommand = ShowCommand


return M
