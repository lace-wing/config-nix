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

      terminal = "ghostty";

      # floating = {
      #   criteria = [
      #     {
      #       app_id = "ibus-ui-gtk3";
      #     }
      #   ];
      # };
    };

    extraConfig = ''
      output "*" bg ~/wallpaper fill #232329
    '';
  };
}
