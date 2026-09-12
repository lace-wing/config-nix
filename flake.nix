{
  description = "A Nix config for macOS and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree = {
      url = "github:vic/import-tree";
      flake = false;
    };

    wrappers.url = "github:lassulus/wrappers";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus.url = "github:dj95/zjstatus";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    plover.url = "github:openstenoproject/plover-flake";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    import-tree,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        (import-tree.filterNot (nixpkgs.lib.hasSuffix ".pkg.nix") ./mod)
      ];
      _module.args.rootPath = ./.;
      debug = true;
    };

  # outputs = inputs @ {
  #   self,
  #   nixpkgs,
  #   ...
  # }: let
  #   mkSystem = import ./lib/mkSystem.nix {
  #     inherit nixpkgs overlays inputs;
  #   };
  #
  #   overlays = with inputs; [
  #     (final: prev: let
  #       system = prev.pkgs.stdenv.hostPlatform.system;
  #       unstable = import inputs.nixpkgs-unstable {
  #         inherit system;
  #         config.allowUnfree = true;
  #       };
  #     in {
  #       typst = unstable.typst;
  #
  #       zjstatus = zjstatus.packages.${system}.default;
  #     })
  #   ];
  # in {
  #   darwinConfigurations.mbp-m1 = mkSystem "mbp-m1" {
  #     system = "aarch64-darwin";
  #     user = "lacewing";
  #     darwin = true;
  #   };
  #
  #   nixosConfigurations.tp-t14 = mkSystem "tp-t14" {
  #     system = "x86_64-linux";
  #     user = "lacewing";
  #     gui = true;
  #   };
  # };
}
