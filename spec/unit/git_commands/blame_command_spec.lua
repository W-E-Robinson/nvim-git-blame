local blame_command = require("git_commands.blame_command")

describe("unit tests: git blame command", function()
    describe("new instantiation", function()
        it(
            "should set the meta table command entry to a table containing the base git blame command",
            function()
                local instance_blame_command = blame_command.BlameCommand:new()

                assert.are.same(
                    instance_blame_command.command,
                    { "git", "blame" }
                )
            end
        )
    end)

    describe("blame_current_line method", function()
        it(
            "should return the commit hash for the given line as in when full git history available (no leading ^)",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                code = 0,
                                system = 0,
                                stdout = "1234567890 (Will Robinson 2026-01-25 21:28:08 +0000 1) # nvim-git-blame",
                                stderr = "",
                            }
                        end,
                    }
                end)

                local instance_blame_command = blame_command.BlameCommand:new()
                local hash = instance_blame_command:blame_current_line(
                    "./redundant_file_path",
                    1
                ).hash

                assert.are.same(hash, "1234567890")

                vim.system:revert()
            end
        )

        it(
            "should return the commit hash for the given line as in when full git history is not available (leading ^)",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                code = 0,
                                system = 0,
                                stdout = "^1234567890 (Will Robinson 2026-01-25 21:28:08 +0000 1) # nvim-git-blame",
                                stderr = "",
                            }
                        end,
                    }
                end)

                local instance_blame_command = blame_command.BlameCommand:new()
                local hash = instance_blame_command:blame_current_line(
                    "./redundant_file_path",
                    1
                ).hash

                assert.are.same(hash, "1234567890")

                vim.system:revert()
            end
        )

        it("should return the commit metadata for the given line", function()
            _G.vim = _G.vim or {}

            stub(vim, "system", function()
                return {
                    wait = function()
                        return {
                            code = 0,
                            system = 0,
                            stdout = "1234567890 (Will Robinson 2026-01-25 21:28:08 +0000 1) # nvim-git-blame",
                            stderr = "",
                        }
                    end,
                }
            end)

            local instance_blame_command = blame_command.BlameCommand:new()
            local metadata = instance_blame_command:blame_current_line(
                "./redundant_file_path",
                1
            ).metadata

            assert.are.same(
                metadata,
                "Will Robinson 2026-01-25 21:28:08 +0000 1"
            )

            vim.system:revert()
        end)

        it("should return the commit content for the given line", function()
            _G.vim = _G.vim or {}

            stub(vim, "system", function()
                return {
                    wait = function()
                        return {
                            code = 0,
                            system = 0,
                            stdout = "1234567890 (Will Robinson 2026-01-25 21:28:08 +0000 1) # nvim-git-blame",
                            stderr = "",
                        }
                    end,
                }
            end)

            local instance_blame_command = blame_command.BlameCommand:new()
            local content = instance_blame_command:blame_current_line(
                "./redundant_file_path",
                1
            ).content

            assert.are.same(content, "# nvim-git-blame")

            vim.system:revert()
        end)
    end)

    describe("commit_hashes_file method", function()
        it(
            "should return a table containing all the file's lines commit hashes",
            function()
                _G.vim = _G.vim or {}

                stub(vim, "system", function()
                    return {
                        wait = function()
                            return {
                                code = 0,
                                system = 0,
                                stdout = "1234567890 1) # hello\n1234567890 2) # world",
                                stderr = "",
                            }
                        end,
                    }
                end)

                local instance_blame_command = blame_command.BlameCommand:new()
                local commit_hashes = instance_blame_command:commit_hashes_file(
                    "./redundant_file_path"
                )

                assert.are.same(commit_hashes, { "1234567890", "1234567890" })

                vim.system:revert()
            end
        )
    end)
end)
