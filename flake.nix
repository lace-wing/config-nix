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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };

    plover = {
      url = "github:openstenoproject/plover-flake";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs overlays inputs;
    };

    overlays = with inputs; [
      (final: prev: let
        system = prev.pkgs.stdenv.hostPlatform.system;
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        typst = unstable.typst;

        zjstatus = zjstatus.packages.${system}.default;
      })
    ];
  in {
    darwinConfigurations.mbp-m1 = mkSystem "mbp-m1" {
      system = "aarch64-darwin";
      user = "lacewing";
      darwin = true;
    };

    nixosConfigurations.tp-t14 = mkSystem "tp-t14" {
      system = "x86_64-linux";
      user = "lacewing";
      gui = true;
    };
  };
}
