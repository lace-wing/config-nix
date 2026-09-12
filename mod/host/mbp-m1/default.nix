{
  self,
  inputs,
  ...
}: {
  flake.darwinConfiguration.mbp-m1 = inputs.darwin.lib.darwinSystem {
    modules = [
      self.darwinModules.mbp-m1
    ];
  };
}
