local M = {}

M.name = (function()
  local osname
  -- ask LuaJIT first
  if jit then
    return jit.os
  end

  -- Unix, Linux variants
  local fh, _ = assert(io.popen('uname -o 2>/dev/null', 'r'))
  if fh then
    osname = fh:read()
  end

  return osname or 'Wisdows'
end)()

M.isunix = vim.fn.has('unix')
M.islinux = vim.fn.has('linux')
M.ismac = vim.fn.has('mac')
M.iswin = vim.fn.has('win32')
M.iswin64 = vim.fn.has('win64')

M.ext = {
  so = (function()
    if M.name == 'Linux' then
      return 'so'
    elseif M.name == 'OSX' then
      return 'dylib'
    elseif M.name == 'Windows' then
      return 'dll'
    end
  end)(),
}

return M
