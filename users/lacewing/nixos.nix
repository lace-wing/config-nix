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
      "video"
    ];
  };

  programs.zsh.enable = true;

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

      # grab-zoom-in=<Logo>Plus
      # grab-zoom-out=<Logo>Minus
      # grab-scroll-up=<Logo>Up
      # grab-scroll-down=<Logo>Down
      # grab-page-up=<Logo>Prior
      # grab-page-down=<Logo>Next
    '';
  };
}
