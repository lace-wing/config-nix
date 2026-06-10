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
    hwRender = false;
    fonts = with pkgs; [
      {
        name = "MonaspiceAr NFM";
        package = nerd-fonts.monaspace;
      }
      {
        name = "Noto Sans Mono CJK SC";
        package = noto-fonts-cjk-sans;
      }
    ];
    extraConfig = ''
      term=xterm-256color
      font-size=16
    '';
  };
}
