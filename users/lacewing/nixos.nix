{
  inputs,
  pkgs,
  user,
  ...
}: {
  nix.optimise.automatic = true;

  environment.etc = {
    "icas".source = ../../mods/icas;
  };

  users.users.lacewing = {
    isNormalUser = true;
    description = "Lacewing";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
  };

  programs.zsh.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "escape";
          };
        };
      };
    };
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = with pkgs; [
      {
        name = "MonaspiceAr NFM";
        package = nerd-fonts.monaspace;
      }
      {
        name = "Noto Sans Mono CJK SC";
        package = noto-fonts-cjk-sans-static;
      }
    ];
    extraConfig = ''
      font-size=20

      palette=custom
      palette-black=35,35,41
      palette-blue=99,150,204
      palette-cyan=222,170,187
      palette-green=118,139,101
      palette-magenta=134,129,173
      palette-red=191,106,115
      palette-light-grey=227,226,227
      palette-yellow=218,187,90
      palette-dark-grey=59,56,68
      palette-white=245,243,245
      palette-light-blue=184,214,230
      palette-light-yellow=247,239,159
      palette-light-cyan=229,202,224
      palette-light-green=157,193,161
      palette-light-red=187,64,69
      palette-light-magenta=180,141,187
      palette-background=21,21,20
      palette-foreground=227,226,227
    '';
  };
}
