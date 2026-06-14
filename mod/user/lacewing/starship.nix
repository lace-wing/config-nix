{...}: let
  # modules called in parallel, git_status usually is the slowest
  disabledModules = [
  ];
in {
  programs.starship = {
    enable = true;

    settings =
      {
        directory = {
          truncation_length = 3;
        };
        format = builtins.concatStringsSep "" [
          "$username"
          "$hostname"
          "$singularity"
          "$kubernetes"
          "$nats"
          "$directory"
          "$fossil_branch"
          "$fossil_metrics"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$hg_state"
          "$pijul_channel"
          "$docker_context"
          "$nix_shell"
          "$direnv"
          "$env_var"
          "$sudo"
          "$cmd_duration"

          "$line_break"
          "$jobs"
          "$container"
          "$shlvl"
          "$character"
        ];
        right_format = builtins.concatStringsSep "" [
          "$status"
        ];
        sudo = {
          disabled = false;
        };
        status = {
          disabled = false;
        };
        shlvl = {
          disabled = false;
          symbol = "|";
          repeat = true;
          repeat_offset = 1;
          format = "[$symbol]($style)";
        };
        add_newline = false;
      }
      // builtins.listToAttrs (map (name: {
          name = name;
          value = {disabled = true;};
        })
        disabledModules);

    presets = [
      "plain-text-symbols"
    ];
  };
}
