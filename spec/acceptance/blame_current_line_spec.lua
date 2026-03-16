-- NOTE: once done thisd file, how tidy and modularise?
--  with text to describe all testing and this in particular in README.md
-- only works when called from top level?
-- we CAN print from inside acceptance test!

-- tests
-- spawns a pop up window when the line is not committed yet = do last as complex!!
-- displays no committed info in pop up window = do last as complex!! = have temp file, round to hello
-- spawns a pop up window for the git information for the line
-- displays git information for the line in the pop up window

describe("acceptance test: BlameCurrentLine", function()
    local test_output = "./test_output"

    after_each(function()
        os.remove(test_output)
    end)

    describe("git tracked line", function()
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

                        -c "lua vim.fn.writefile({tostring(#vim.api.nvim_list_wins())}, '%s')" \

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
            "spawned pop up window displays the git information for the line",
            function()
                local cmd = string.format(
                    [[
            nvim --headless -u NORC spec/acceptance/git_tracked_file.txt \
            -c "lua package.path = './lua/?.lua;./lua/?/init.lua;'..package.path" \
            -c "lua local m = require('nvim_git_blame'); vim.api.nvim_create_user_command('BlameCurrentLine', m.blame_current_line, {})" \
            -c "lua require('nvim_git_blame')" \
            -c "BlameCurrentLine" \
            -c "lua vim.fn.writefile({tostring(#vim.api.nvim_list_wins())}, '%s')" \
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
    end)
end)
