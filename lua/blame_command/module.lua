local M = {}

-- will have other git commands, inherit for start slef git and then executing?

function M.GitCommand()
    local self = { command = { 'git' } }

    local append_to_command = function(option) self.command[#self.command + 1] = option end

    local execute_command = function()
        return vim.system(self.command, { text = true }):wait()
        -- code, signal, stdout, stderr
    end

    return {
        append_to_command = append_to_command,
        execute_command = execute_command,
    }
end

function M.BlameCommand()
    local self = { command = { 'git', 'blame' } }

    local append_to_command = function(option) self.command[#self.command + 1] = option end

    local apply_file_path = function(file_path)
        append_to_command(file_path)
    end

    local blame_current_line = function(current_row)
        append_to_command("-L")
        append_to_command(string.format("%d,+1", current_row))
    end

    local execute_command = function()
        return vim.system(self.command, { text = true }):wait()
        -- code, signal, stdout, stderr
    end

    return {
        apply_file_path = apply_file_path,
        blame_current_line = blame_current_line,
        execute_command = execute_command,
    }
end

return M
