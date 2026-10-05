---@type vim.lsp.Config
return {
  cmd = { 'lean --server' },
  filetypes = { 'lean' },
  root_markers = { 'lakefile.toml', '.git' },
}
