---@brief Source: <https://github.com/neovim/nvim-lspconfig/blob/5955a100ae7155962330643924e21a798b9bdc91/lua/lspconfig/util.lua>, edited.

local M = {}

--- Returns a function which matches a filepath against the given pattern/glob patterns.
---
--- Also works with zipfile:/tarfile: buffers (via `strip_archive_subpath`).
---@param patterns table
---@param glob boolean|nil
---@return function
local function dir_search_up(patterns, glob)
  glob = glob or false
  local pred = string.match
  if glob then
    patterns = vim.tbl_map(function(v)
      return vim.regex(vim.fn.glob2regpat(v))
    end, patterns)
    ---@param name string
    ---@param pattern vim.regex
    pred = function(name, pattern) return pattern:match_str(name) end
  end
  return function(startpath)
    startpath = vim.fs.dirname(M.strip_archive_subpath(startpath))
    local match = vim.fs.find(function(name, _)
        for _, pattern in ipairs(patterns) do
          if pred(name, pattern) then
            return true
          end
        end
        return false
      end,
      { path = startpath, upward = true, follow = true })[1]

    if match ~= nil then
      match = vim.fs.dirname(match)
      local real = vim.uv.fs_realpath(match)
      return real or match -- fallback to original if realpath fails
    end
  end
end

function M.root_pattern(...)
  local patterns = vim.iter({ ... }):flatten(math.huge):totable()
  return dir_search_up(patterns)
end

function M.root_glob(...)
  local patterns = vim.iter({ ... }):flatten(math.huge):totable()
  return dir_search_up(patterns, true)
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

return M
