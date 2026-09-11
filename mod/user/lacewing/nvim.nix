{
  lib,
  config,
  pkgs,
  user,
  isDarwin,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;

  vim-macos-ime = pkgs.vimUtils.buildVimPlugin {
    name = "vim-macos-ime";
    src = pkgs.fetchFromGitHub {
      owner = "laishulu";
      repo = "vim-macos-ime";
      rev = "master";
      sha256 = "tQYq/DWb6j+FIAxuA861ct/ym/1y1oROJgk8hqp0rZ0=";
    };
  };

  slang-server = let
    assets = {
      x86_64-linux = {
        postfix = "linux-x64";
        hash = "sha256-Ka2R8kXxADN8Nc4n26cR1fDqUOvHDnPHjisnQAqHrmI=";
      };
      aarch64-darwin = {
        postfix = "macos";
        hash = "sha256-hs+eyXSixikfTEa+vfT8LRd0y0fgk00GQ6vKz4xMkWo=";
      };
    };

    sysAsset = assets.${system} or (throw "Unsupported system: ${system}");
  in
    pkgs.stdenv.mkDerivation rec {
      pname = "slang-server";
      version = "0.3.0";

      sourceRoot = ".";

      src = pkgs.fetchurl {
        url = "https://github.com/hudson-trading/slang-server/releases/download/v${version}/slang-server-${sysAsset.postfix}.tar.gz";
        hash = sysAsset.hash;
      };

      installPhase = ''
        install -D ${pname} $out/bin/${pname}
      '';
    };
in {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins;
      [
        ## completion ##
        blink-cmp
        mini-snippets
        ## colors ##
        mini-hipatterns
        alabaster-nvim
        ## debugging ##
        nvim-dap
        nvim-dap-virtual-text
        ## lsp ##
        conform-nvim
        nvim-origami
        easy-dotnet-nvim
        ## tree-sitter ##
        (nvim-treesitter.withPlugins (p:
          with p; [
            c
            cpp
            zig
            go
            lua
            python
            rust
            c_sharp
            fsharp
            haskell
            elixir
            eex
            heex
            nu
            typst
            objdump
            html
          ]))
        nvim-treesitter-context
        nvim-treesitter-textobjects
        ## diagnostics ##
        trouble-nvim
        ## misc ##
        oil-nvim
        mini-pick
        mini-pairs
        mini-surround
        mini-git
        mini-diff
        which-key-nvim
        vim-slime
      ]
      ++ lib.optionals isDarwin [
        vim-macos-ime
      ];
    extraPackages = with pkgs;
      [
        tree-sitter
        alejandra
        lua-language-server
        pyright
        tinymist
        roslyn-ls
        fsautocomplete
        fantomas
        nixd
        elixir-ls
        zls
        nasmfmt
        rust-analyzer
        topiary
        slang-server
      ]
      ++ (with haskellPackages; [
        haskell-language-server
        ormolu
        cabal-fmt
      ]);
  };

  xdg.configFile = {
    "nvim/".source = ./nvim;
    "topiary/".source = ./topiary;
  };

  home.sessionVariables = with config.home.sessionVariables; {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    NVIM_CONFIG_DIR = "${NIX_CONFIG_DIR}/mod/user/${user}/nvim";
  };

  home.shellAliases = with config.home.sessionVariables; {
    nrc = "${EDITOR} ${NVIM_CONFIG_DIR}";
  };
}
