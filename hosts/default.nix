{
  self,
  inputs,
  self',
  inputs',
  ...
}: {
  flake.nixosConfigurations.sforza = self.nixos-flake.lib.mkLinuxSystem {
    imports = [
      ./sforza
      ../modules/core
      ../modules/graphical
      ../modules/secrets

      inputs.impermanence.nixosModule
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
