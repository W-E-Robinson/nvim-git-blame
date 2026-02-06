local utils = require("utils.module")

describe("unit tests: utils", function()
    describe("strip_new_lines_from_string", function()
        it("should strip newlines from a string", function()
            local str = "end of the line\n"
            assert.are.same(
                utils.strip_new_lines_from_string(str),
                "end of the line"
            )
        end)
    end)

    describe("remove_leading_caret_from_string", function()
        it("should remove the leading caret from a string", function()
            local str = "^12345"
            assert.are.same(
                utils.remove_leading_caret_from_string(str),
                "12345"
            )
        end)
    end)

    describe("is_line_full_history_available", function()
        it(
            "return true is there is no leading caret in the commit hash",
            function()
                local commit_hash = "12345"
                assert.are.same(
                    utils.is_line_full_history_available(commit_hash),
                    true
                )
            end
        )

        it(
            "return false is there is a leading caret in the commit hash",
            function()
                local commit_hash = "^12345"
                assert.are.same(
                    utils.is_line_full_history_available(commit_hash),
                    false
                )
            end
        )
    end)

    describe("split_into_lines", function()
        it(
            "should split a string into a table containing the individual lines",
            function()
                local str = "hello\nthere\n\nworld"
                assert.are.same(
                    utils.split_into_lines(str),
                    { "hello", "there", "", "world" }
                )
            end
        )
    end)

    describe("is_change_not_committed_yet", function()
        it(
            "should return true if a commit hash indicates an uncommitted change",
            function()
                local commit_hash = "00000000"
                assert.are.same(
                    utils.is_change_not_committed_yet(commit_hash),
                    true
                )
            end
        )

        it(
            "should return false if a commit hash indicates a committed change",
            function()
                local commit_hash = "12345"
                assert.are.same(
                    utils.is_change_not_committed_yet(commit_hash),
                    false
                )
            end
        )
    end)
end)
