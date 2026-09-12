{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.tp-t14 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.tp-t14
    ];
  };
}
