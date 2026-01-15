local M = {}

local BaseCommand = {}
BaseCommand.__index = BaseCommand

function BaseCommand:new(cmd)
    return setmetatable({
        command = cmd,
        code = nil,
        signal = nil,
        stdout = nil,
        stderr = nil,
    }, self)
end

function BaseCommand:append(option)
    table.insert(self.command, option)
end

function BaseCommand:execute()
    local execution_result = vim.system(self.command, { text = true }):wait()
    self.code = execution_result.code
    self.signal = execution_result.signal
    self.stdout = execution_result.stdout
    self.stderr = execution_result.stderr
end

M.BaseCommand = BaseCommand

return M
