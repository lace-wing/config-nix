{
  isLinux,
  isGui,
  ...
}: let
in {
  wayland.windowManager.sway = {
    enable = isLinux && isGui;

    config = {
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      window = {
        titlebar = false;
      };

      terminal = "ghostty";
    };

    extraConfig = ''
      output "*" bg ~/wallpaper fill #232329
    '';
  };
}
