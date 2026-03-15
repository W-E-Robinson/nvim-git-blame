describe("nvim split", function()
    local temp_file = "./temp_file"

    after_each(function()
        os.remove(temp_file)
    end)

    it("creates two windows", function()
        local cmd = string.format([[
        nvim --headless \
        -c "lua vim.cmd('split')" \
        -c "lua vim.fn.writefile({tostring(#vim.api.nvim_list_wins())}, '%s')" \
        -c "qa!"
        ]], temp_file)

        os.execute(cmd)

        local f = io.open(temp_file, "r")
        local output = f:read("*l")

        assert.are.same(output, "2")
    end)
end)
