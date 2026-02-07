local show_command = require("git_commands.show_command")

describe("unit tests: git blame command", function()
    describe("new instantiation", function()
        it(
            "should set the meta table command entry to a table containing the base git blame command and the commit hash",
            function()
                local instance_show_command =
                    show_command.ShowCommand:new("1234567890")

                assert.are.same(
                    instance_show_command.command,
                    { "git", "show", "1234567890" }
                )
            end
        )
    end)

    describe("suppress diff method", function()
        it("should append the no patch tag to the git show command", function()
            local instance_show_command =
                show_command.ShowCommand:new("1234567890")
            instance_show_command:suppress_diff()

            assert.are.same(
                instance_show_command.command,
                { "git", "show", "1234567890", "--no-patch" }
            )
        end)
    end)

    describe("format_output method", function()
        it(
            "should append the git show output in the supplied format to the command",
            function()
                local instance_show_command =
                    show_command.ShowCommand:new("1234567890")
                instance_show_command:format_output("medium")

                assert.are.same(
                    instance_show_command.command,
                    { "git", "show", "1234567890", "--format=medium" }
                )
            end
        )
    end)

    describe("commit_stdout_for_hash method", function()
        it("should return medium formatted git show stdout", function()
            _G.vim = _G.vim or {}

            stub(vim, "system", function()
                return {
                    wait = function()
                        return {
                            code = 0,
                            system = 0,
                            stdout = "Author: Will Robinson <william.ellis.robinson@gmail.com>\nDate:   Sun Jan 25 21:28:08 2026 +0000\n\nInitial commit with v1.0.0",
                            stderr = "",
                        }
                    end,
                }
            end)

            local instance_show_command = show_command.ShowCommand:new()
            local hash = instance_show_command:commit_stdout_for_hash()

            assert.are.same(
                hash,
                "Author: Will Robinson <william.ellis.robinson@gmail.com>\nDate:   Sun Jan 25 21:28:08 2026 +0000\n\nInitial commit with v1.0.0"
            )

            vim.system:revert()
        end)
    end)
end)
