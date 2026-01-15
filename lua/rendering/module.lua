local constants = require("constants.module")

local M = {}

function M.display_buf_text_central_pop_up(buf, height)
    local width = constants.CENTRAL_POP_UP_WIDTH

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = (height > constants.CENTRAL_POP_UP_MAX_HEIGHT and constants.CENTRAL_POP_UP_MAX_HEIGHT or height),
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded"
    })
end

return M
