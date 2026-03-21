-- striuctre
---- pull setup into separate
---- and closing of instance
-- with text to describe all testing and this in particular in README.md
---- only works when called from top level?

describe("acceptance test: BlameCurrentLine", function()
    local test_output = "./test_output"

    after_each(function()
        os.remove(test_output)
    end)

    describe("file with committed line", function()
        it(
            "spawns a pop up window when BlameCurrentLine is called on the line",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({#vim.api.nvim_list_wins()}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local num_windows = f:read("*l")

                assert.are.same(num_windows, "2")
            end
        )

        it(
            "spawned pop up window displays the commit information title",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua local win = vim.api.nvim_get_current_win(); local title = vim.api.nvim_win_get_config(win).title; vim.fn.writefile({title[1][1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(pop_up_text, "Commit Information")
            end
        )

        it(
            "spawned pop up window displays the commit information in the first line",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 0, 1, false)[1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(
                    pop_up_text,
                    "commit 6a1c51c4e52979de123e4a2d41fde4592dfd3c9d"
                )
            end
        )

        it(
            "spawned pop up window displays the commiters name and email information in the second line",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 1, 2, false)[1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(
                    pop_up_text,
                    "Author: Will Robinson <william.ellis.robinson@gmail.com>"
                )
            end
        )

        it(
            "spawned pop up window displays the datetime of the commit in the third line",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 2, 3, false)[1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(
                    pop_up_text,
                    "Date:   Mon Mar 16 21:54:25 2026 +0000"
                )
            end
        )

        it(
            "spawned pop up window begins to display commit message in the fifth line (after line space)",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 4, 5, false)[1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(
                    pop_up_text,
                    '    test: added first acceptance for "spawns a pop up window when BlameCurrentLine'
                )
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
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/updated_git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({#vim.api.nvim_list_wins()}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local num_windows = f:read("*l")

                assert.are.same(num_windows, "2")
            end
        )

        it(
            "spawned pop up window displays the commit information title",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/updated_git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua local win = vim.api.nvim_get_current_win(); local title = vim.api.nvim_win_get_config(win).title; vim.fn.writefile({title[1][1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(pop_up_text, "Commit Information")
            end
        )

        it(
            "spawned pop up window displays the not yet committed message in the first line",
            function()
                local cmd = string.format(
                    [[
                        nvim --headless -u NORC spec/acceptance/updated_git_tracked_file.txt \
                        -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
                        -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
                        -c "lua require('nvim_git_blame')" \
                        -c "BlameCurrentLine" \
                        -c "lua vim.fn.writefile({vim.api.nvim_buf_get_lines(2, 0, 1, false)[1]}, '%s')" \
                        -c "qa!"
                    ]],
                    test_output
                )

                os.execute(cmd)

                local f = io.open(test_output, "r")
                local pop_up_text = f:read("*l")

                assert.are.same(pop_up_text, "Not committed yet...")
            end
        )
    end)
end)
