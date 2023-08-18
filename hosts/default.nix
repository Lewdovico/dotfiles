{
  self,
  inputs,
  self',
  inputs',
  ...
}: {
  /*
  TODO: use flake.nixosModules
  https://github.com/srid/nixos-flake/blob/master/examples/both/flake.nix#L88
  */
  flake.nixosConfigurations.sforza = self.nixos-flake.lib.mkLinuxSystem {
    imports = [
      ./sforza
      ../modules/core
      ../modules/graphical
      ../modules/secrets

      inputs.aagl.nixosModules.default
      inputs.chaotic.nixosModules.default
      inputs.impermanence.nixosModule
      inputs.nh.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      self.nixosModules.home-manager
      {
        _module.args = {inherit self' self inputs' inputs;};
        home-manager.extraSpecialArgs = {inherit self' self inputs' inputs;};
        home-manager.users.ludovico = {
          imports = [self.homeModules.ludovico];

          home.stateVersion = "22.11";
        };
      }
    ];
  };
}
