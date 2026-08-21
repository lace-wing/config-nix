local map = require('util.vim').map

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "text",
    "gitcommit",
    "markdown",
    "typst",
    "asciidoc"
  },
  callback = function()
    vim.opt_local.spell = true
  end,
})

require('trouble').setup({
  auto_preview = false,
})

map('n', '<LEADER>xx', '<CMD>Trouble diagnostics toggle<CR>')
map('n', '<LEADER>xr', '<CMD>Trouble lsp_references toggle<CR>')
map('n', '<LEADER>xs', '<CMD>Trouble symbols toggle<CR>')
map('n', '<LEADER>xq', '<CMD>Trouble qflist toggle<CR>')
