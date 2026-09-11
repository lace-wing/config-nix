{
  pkgs,
  isLinux,
  isGui,
  ...
}: let
  l = pkgs.lib;
in {
  wayland.windowManager.sway = {
    enable = isLinux && isGui;

    config = rec {
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      terminal = "ghostty";
    };
  };
}
