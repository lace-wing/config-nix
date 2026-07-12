local u = require('util')
local map = u.vim.map

vim.diagnostic.config({
  virtual_lines = true,
})

vim.lsp.inlay_hint.enable()

vim.lsp.enable({
  'clangd',
  'lua_ls',
  'pyright',
  'tinymist',
  'easy_dotnet',
  'fsautocomplete',
  'nixd',
  'elixirls',
  'hls',
  'zls',
  'nu',
})

local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    nu = { 'topiary' },
    asm = { 'nasmfmt' },
  },
  formatters = {
    topiary = {
      command = 'topiary',
      -- Topiary needs file extension to detect language.
      args = { 'format', '$FILENAME' },
      stdin = false,
    },
    nasmfmt = {
      command = 'nasmfmt',
      -- nasmfmt does not use stdin
      args = { '$FILENAME' },
      stdin = false,
    },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

map('n', '<LEADER>l', conform.format, { desc = 'Format' })

require('origami').setup({
  autoFold = {
    enabled = true,
    kinds = { "imports" }, ---@type lsp.FoldingRangeKind[]
  },
  foldKeymaps = {
    setup = false,                  -- modifies `h`, `l`, `^`, and `$`
    closeOnlyOnFirstColumn = false, -- `h` and `^` only fold in the 1st column
    scrollLeftOnCaret = false,      -- `^` should scroll left (basically mapped to `0^`)
  },
})
