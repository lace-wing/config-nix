{
  #TODO add gui/de flag
  isWSL,
  inputs,
  user,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  fontPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    crimson-pro
    nerd-fonts.monaspace
    nerd-fonts.iosevka
    fira-mono
    aptos-fonts
  ];

  zshFunctions = builtins.readFile ./zsh/functions.sh;
  nuCommands = builtins.readFile ./nushell/commands.nu;
  nuHooks = builtins.readFile ./nushell/hooks.nu;
in {
  home.stateVersion = "26.05";

  imports = [
    inputs.plover.homeManagerModules.plover
    ./neovim.nix
    ./starship.nix
    ./zellij.nix
  ];

  _module.args = {
    inherit
      user
      isDarwin
      isLinux
      isWSL
      ;
  };

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = with pkgs;
    [
      ### Lang ###
      clang-tools
      typst

      ### Lib ###
      man-pages
      man-pages-posix

      ### Tool ###
      below
      _7zz
      outfieldr
      fd
      fzf
      gdu
      gh
      jq
      ripgrep
      tree
      flamegraph
      clipboard-jh
      exiftool
      imagemagick
      poppler-utils
      pdfpc
      ffmpeg
      mpv
      giac
      weechat
      elinks
    ]
    ++ fontPackages
    ++ lib.optionals isDarwin [
      # This is automatically setup on Linux
      gettext
      macism
    ]
    ++ lib.optionals (isLinux && !isWSL) [
      valgrind
    ];

  #---------------------------------------------------------------------
  # Path
  #---------------------------------------------------------------------

  home.sessionPath = [
    "$HOME/app/bin"
  ];

  #---------------------------------------------------------------------
  # Env and config files
  #---------------------------------------------------------------------

  fonts.fontconfig = {
    enable = true;

    # packages in fontPkgs
    defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "MonaspiceAr NFM"
        "Noto Sans Mono CJK SC"
      ];
    };
  };

  home.sessionVariables = with config.home.sessionVariables;
    {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";

      NIX_CONFIG_DIR = "${config.xdg.configHome}/system";
      ZSH_CONFIG_DIR = "${NIX_CONFIG_DIR}/users/${user}/zsh";

      X_SRC_DIR = "$HOME/src";
      Y_SRC_DIR = "$HOME/srcy";

      UNI_DIR = "${Y_SRC_DIR}/study";
    }
    // lib.optionalAttrs isDarwin {
      # See: https://github.com/NixOS/nixpkgs/issues/390751
      DISPLAY = "nixpkgs-390751";
    };

  xdg.configFile = {
    "ghostty/".source = ./ghostty;
    "aerospace/".source = ./aerospace;
    "skhd/".source = ./skhd;
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = !isDarwin;

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;

    # Cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  programs.npm = {
    enable = false;
    settings = {
      ignore-scripts = true;
      provenance = true;
      save-exact = true;
      save-prefix = "";
      # days
      min-release-age = 7;
    };
  };

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
  };

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile ./zsh/zshrc;
    profileExtra = lib.concatStringsSep "\n" [
      # (builtins.readFile ./zsh/zprofile)
      zshFunctions
    ];
  };

  programs.nushell = {
    enable = true;
    extraConfig = lib.concatStringsSep "\n" [
      nuHooks
      nuCommands
    ];
    settings = {
      show_banner = false;
      footer_mode = "auto";
      table = {
        missing_value_symbol = "♡";
        mode = "frameless";
        trim = {
          methodology = "truncating";
          truncating_suffix = "...";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        exact = ["~/.envrc"];
        prefix = [
          "~/src"
          "~/srcy"
        ];
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.carapace = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "lace-wing";
        email = "lycrlsu01@gmail.com";
      };
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.pandoc = {
    enable = true;
  };

  programs.plover = {
    enable = true;
    package =
      inputs.plover.packages.${pkgs.stdenv.hostPlatform.system}.plover.withPlugins (ps: [
      ]);
  };

  programs.sioyek = {
    enable = true;

    config = {
      startup_commands = [
        "toggle_titlebar"
        "toggle_dark_mode"
      ];
      "show_doc_path" = "1";
    };
    bindings = {
      "open_document_embedded_from_current_path" = "e";
      "open_prev_doc" = "E";
      "open_all_docs" = "<C-e>";
    };
  };

  programs.ghostty = {
    enable = true;
    # settings = xdg files
    installVimSyntax = true;
    package =
      if isDarwin
      then pkgs.ghostty-bin # Nix does not support Swift 6 and Xcode build env yet.
      else pkgs.ghostty;
  };

  programs.yazi = {
    enable = true;
  };

  programs.sketchybar = {
    enable = isDarwin;
    config = {
      recursive = true;
      source = ./sketchybar;
    };
  };

  programs.aerospace = {
    enable = isDarwin;
    # settings = xdg.configFile
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "host"
        "cpu"
        "gpu"
        "display"
        "separator"
        "os"
        "kernel"
        {
          type = "command";
          key = "Config";
          text = ./fastfetch/scripts/config-credit.nu;
        }
        "de"
        "wm"
        {
          type = "command";
          key = "Wallpaper";
          text = "${./fastfetch/scripts/image-credit.nu} ~/wallpaper";
        }
        "theme"
        "font"
        "terminal"
        "terminalfont"
        "shell"
        "editor"
        "break"
        "colors"
      ];
    };
  };

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  #---------------------------------------------------------------------
  # Aliases
  #---------------------------------------------------------------------

  home.shellAliases = with config.home.sessionVariables;
    {
      # Use common flags for nushell compat
      l = "ls -l";
      la = "ls -a";
      ll = "ls -la";

      rc = "${EDITOR} ${NIX_CONFIG_DIR}";
      zrc = "${EDITOR} ${ZSH_CONFIG_DIR}/zshrc";

      men = "tldr";
      human = "tldr_fzf_preview";

      cd = "z";
      cdd = "cd_git_top";

      v = "${EDITOR}";
      vv = "fzf_editor";
    }
    // lib.optionalAttrs isDarwin {
      cddc = "cd ~/Documents/";
      cddw = "cd ~/Downloads/";
      cdds = "cd ~/Desktop/";
      cdpc = "cd ~/Pictures/";
      cdss = "cd ~/Pictures/Screen\\ Shot/";
      cdas = "cd ~/Library/Application\\ Support/";
      cdic = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";
    };
}
