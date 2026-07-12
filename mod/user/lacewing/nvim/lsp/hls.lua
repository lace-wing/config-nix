---@brief
---
--- https://github.com/haskell/haskell-language-server
---
--- Haskell Language Server
---
--- If you are using HLS 1.9.0.0, enable the language server to launch on Cabal files as well:
---
--- ```lua
--- vim.lsp.config('hls', {
---   filetypes = { 'haskell', 'lhaskell', 'cabal' },
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml' }))
  end,
  settings = {
    haskell = {
      formattingProvider = 'ormolu',
      cabalFormattingProvider = 'cabal-fmt',
    },
  },
}
