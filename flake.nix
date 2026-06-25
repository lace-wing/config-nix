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
      inputs.nixpkgs.follows = "nixpkgs";
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

        aptos-fonts = prev.pkgs.stdenvNoCC.mkDerivation {
          pname = "aptos-fonts";
          version = "4.4.0";
          src = prev.pkgs.fetchzip {
            url = "https://download.microsoft.com/download/8/6/0/860a94fa-7feb-44ef-ac79-c072d9113d69/Microsoft%20Aptos%20Fonts.zip";
            name = "microsoft-aptos-fonts.zip";
            sha256 = "sha256-jkYOP5upe+zMnuQtDLCAcaG1ocbx1iHm1ygW9pqGTig=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
          '';
        };
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
      gui = false;
    };
  };
}
