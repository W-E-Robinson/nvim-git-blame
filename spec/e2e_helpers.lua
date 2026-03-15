-- tests/e2e_helpers.lua
local M = {}

function M.run(lua_code)
  local tmp = os.tmpname() .. ".lua"

  local f = assert(io.open(tmp, "w"))
  f:write(lua_code)
  f:close()

  local cmd = string.format(
    "nvim --headless -u tests/minimal_init.lua -c 'luafile %s' -c 'qa!'",
    tmp
  )

  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()

  os.remove(tmp)

  return output
end

return M
