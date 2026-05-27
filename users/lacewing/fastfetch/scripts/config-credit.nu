#!/usr/bin/env nu

def main [] {
  let url = "https://github.com/lace-wing/config-nix"
  let ref = "https://github.com/mitchellh/nixos-config"
  $"(ansi reset)via (ansi blue)nix(ansi reset) on (ansi light_green)($url)"
}
