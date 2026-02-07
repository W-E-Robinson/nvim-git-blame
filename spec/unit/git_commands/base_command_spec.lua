local base_command = require("git_commands.base_command")

describe("unit tests: git base command", function()
    describe("new instantiation", function()
        it(
            "should set the meta table command entry to the passed in table",
            function()
                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)

                assert.are.same(diff_base_command.command, { "git", "diff" })
            end
        )

        it("should set the code entry to nil", function()
            local git_command_table = { "git", "diff" }
            local diff_base_command =
                base_command.BaseCommand:new(git_command_table)

            assert.are.same(diff_base_command.code, nil)
        end)

        it("should set the signal entry to nil", function()
            local git_command_table = { "git", "diff" }
            local diff_base_command =
                base_command.BaseCommand:new(git_command_table)

            assert.are.same(diff_base_command.signal, nil)
        end)

        it("should set the stdout entry to nil", function()
            local git_command_table = { "git", "diff" }
            local diff_base_command =
                base_command.BaseCommand:new(git_command_table)

            assert.are.same(diff_base_command.stdout, nil)
        end)

        it("should set the stderr entry to nil", function()
            local git_command_table = { "git", "diff" }
            local diff_base_command =
                base_command.BaseCommand:new(git_command_table)

            assert.are.same(diff_base_command.stderr, nil)
        end)
    end)

    describe("append method", function()
        it(
            "should append an argument at the end of the command table entry",
            function()
                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)
                diff_base_command:append("--staged")

                assert.are.same(
                    diff_base_command.command,
                    { "git", "diff", "--staged" }
                )
            end
        )
    end)

    describe("execute method", function()
        it(
            "should set the code entry to code output from the vim system command",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                code = 0,
                            }
                        end,
                    }
                end)

                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)

                diff_base_command:execute()

                assert.are.same(0, diff_base_command.code)

                vim.system:revert()
            end
        )

        it(
            "should set the signal entry to signal output from the vim system command",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                signal = 0,
                            }
                        end,
                    }
                end)

                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)

                diff_base_command:execute()

                assert.are.same(0, diff_base_command.signal)

                vim.system:revert()
            end
        )

        it(
            "should set the stdout entry to code output from the vim system command",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                stdout = "stdout string",
                            }
                        end,
                    }
                end)

                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)

                diff_base_command:execute()

                assert.are.same("stdout string", diff_base_command.stdout)

                vim.system:revert()
            end
        )

        it(
            "should set the stderr entry to stderr output from the vim system command",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                stderr = "stderr string",
                            }
                        end,
                    }
                end)

                local git_command_table = { "git", "diff" }
                local diff_base_command =
                    base_command.BaseCommand:new(git_command_table)

                diff_base_command:execute()

                assert.are.same("stderr string", diff_base_command.stderr)

                vim.system:revert()
            end
        )
    end)
end)
