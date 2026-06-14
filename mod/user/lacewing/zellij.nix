{pkgs, ...}: {
  home.packages = with pkgs; [
    zjstatus
  ];

  programs.zellij = {
    enable = true;
  };

  xdg.configFile = {
    "zellij/" = {
      source = ./zellij;
      recursive = true;
    };
    "zellij/plugins/zjstatus.wasm".source = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  };

  home.shellAliases = {
    zl = "zellij";
    za = "zellij action";
    zz = "zellij attach --create";
    zm = "zellij_session_layout Main main";
    zu = "zellij_session_layout Uni uni";
  };
}
