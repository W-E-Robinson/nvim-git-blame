describe("acceptance test: BlameCurrentLine", function()
    local test_output

    before_each(function()
        test_output = os.tmpname()
    end)

    after_each(function()
        os.remove(test_output)
    end)

    ---Runs BlameCurrentLine on a file in a headless nvim, then runs a lua
    ---snippet that writes the value under test to the test output file, this can
    ---then be asserted against in the test.
    ---@param file string file to open nvim with
    ---@param lua_to_run string lua command containing a single `%s`
    ---placeholder for the test output path to write to
    ---@return string output first line written to the test output file
    local function run_cmds_and_get_output(file, lua_to_run)
        local cmd = string.format(
            [[
                nvim --headless -u NORC %s \
                -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                -c "lua require('nvim_git_blame')" \
                -c "BlameCurrentLine" \
                -c "%s" \
                -c "qa!"
            ]],
            file,
            string.format(lua_to_run, test_output)
        )

        os.execute(cmd)

        local f = assert( -- assertion purely for nil check
            io.open(test_output, "r"),
            "failed to open test output"
        )

        local output = f:read("*l")
        f:close()

        return output
    end

    describe("file with committed line", function()
        it(
            "spawns a pop up window when BlameCurrentLine is called on the line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.writefile({#vim.api.nvim_list_wins()}, '%s')]]
                )

                assert.are.same("2", output)
            end
        )

        it(
            "spawned pop up window displays the commit information title",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua local win = vim.api.nvim_get_current_win(); local title = vim.api.nvim_win_get_config(win).title; vim.fn.writefile({title[1][1]}, '%s')]]
                )

                assert.are.same(output, "Commit Information")
            end
        )

        it(
            "spawned pop up window displays the commit information in the first line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 0, 1, false)[1]}, '%s')]]
                )

                assert.are.same(
                    output,
                    "commit 06eaed1daf8b0c0f6f8e5b0ceb56685e031faf9d"
                )
            end
        )

        it(
            "spawned pop up window displays the commiters name and email information in the second line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 1, 2, false)[1]}, '%s')]]
                )

                assert.are.same(
                    output,
                    "Author: Will Robinson <william.ellis.robinson@gmail.com>"
                )
            end
        )

        it(
            "spawned pop up window displays the datetime of the commit in the third line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 2, 3, false)[1]}, '%s')]]
                )

                assert.are.same(
                    output,
                    "Date:   Mon Mar 16 21:54:25 2026 +0000"
                )
            end
        )

        it(
            "spawned pop up window begins to display commit message in the fifth line (after line space)",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 4, 5, false)[1]}, '%s')]]
                )

                assert.are.same(
                    output,
                    '    test: added first acceptance for "spawns a pop up window when BlameCurrentLine'
                )
            end
        )

        it(
            "should copy the hash into the clipboard when pressing 'c' in normal mode when focused on the modal",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/git_tracked_file.txt",
                    [[lua vim.fn.setreg('+', 'placeholder'); vim.cmd.normal({ 'c' }); vim.fn.writefile({ vim.fn.getreg('+') }, '%s')]]
                )

                assert.are.same(output, "06eaed1d")
            end
        )
    end)

    describe("file with uncommitted line", function()
        local ORIGINAL_FIRST_LINE_CONTENTS =
            "Do NOT update this file in any way, acceptance tests rely on it being untouched!"

        before_each(function()
            local file =
                io.open("spec/acceptance/updated_git_tracked_file.txt", "r")
            local file_content = {}
            for line in file:lines() do
                table.insert(file_content, line)
            end
            io.close(file)

            file_content[1] = "This line has been edited"

            file = io.open("spec/acceptance/updated_git_tracked_file.txt", "w")
            for _, value in ipairs(file_content) do
                file:write(value .. "\n")
            end
            io.close(file)
        end)

        after_each(function()
            local file =
                io.open("spec/acceptance/updated_git_tracked_file.txt", "r")
            local file_content = {}
            for line in file:lines() do
                table.insert(file_content, line)
            end
            io.close(file)

            file_content[1] = ORIGINAL_FIRST_LINE_CONTENTS

            file = io.open("spec/acceptance/updated_git_tracked_file.txt", "w")
            for _, value in ipairs(file_content) do
                file:write(value .. "\n")
            end
            io.close(file)
        end)

        it(
            "spawns a pop up window when BlameCurrentLine is called on the line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/updated_git_tracked_file.txt",
                    [[lua vim.fn.writefile({#vim.api.nvim_list_wins()}, '%s')]]
                )

                assert.are.same(output, "2")
            end
        )

        it(
            "spawned pop up window displays the commit information title",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/updated_git_tracked_file.txt",
                    [[lua local win = vim.api.nvim_get_current_win(); local title = vim.api.nvim_win_get_config(win).title; vim.fn.writefile({title[1][1]}, '%s')]]
                )

                assert.are.same(output, "Commit Information")
            end
        )

        it(
            "spawned pop up window displays the not yet committed message in the first line",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/updated_git_tracked_file.txt",
                    [[lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 0, 1, false)[1]}, '%s')]]
                )

                assert.are.same(output, "Not committed yet...")
            end
        )

        it(
            "should not be able to copy the hash into the clipboard using 'c' in normal mode",
            function()
                local output = run_cmds_and_get_output(
                    "spec/acceptance/updated_git_tracked_file.txt",
                    [[lua vim.fn.setreg('+', 'placeholder'); vim.cmd.normal({ 'c' }); vim.fn.writefile({ vim.fn.getreg('+') }, '%s')]]
                )

                assert.are.same(output, "placeholder")
            end
        )
    end)
end)
