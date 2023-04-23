{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs branches
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Default nixpkgs for packages and modules
    nixpkgs.follows = "unstable";

    # Flake inputs
    home.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/hyprland?rev=2df0d034bc4a18fafb3524401eeeceaa6b23e753";
    hyprland-contrib.url = "github:hyprwm/contrib";
    impermanence.url = "github:nix-community/impermanence";
    nil.url = "github:oxalica/nil";
    nix.url = "github:nixos/nix";
    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nix-colors.url = "github:Misterio77/nix-colors";
    spicetify.url = "github:the-argus/spicetify-nix";
    statix.url = "github:nerdypepper/statix";

    # Minimize duplicate instances of inputs
    home.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    nix.inputs.nixpkgs.follows = "nixpkgs";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    statix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    home,
    nixpkgs,
    ...
  } @ inputs: let
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    filterNixFiles = k: v: v == "regular" && nixpkgs.lib.hasSuffix ".nix" k;

    importNixFiles = path:
      with nixpkgs.lib;
        (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
            (filterAttrs filterNixFiles (builtins.readDir path))))
        import;

    overlays = with inputs;
      []
      # Overlays from ./overlays directory
      ++ (importNixFiles ./overlays);
  in {
    nixosConfigurations = {
      sforza = import ./hosts/sforza {
        inherit config nixpkgs overlays inputs;
      };
    };

    homeConfigurations = {
      ludovico = import ./users/ludovico {
        inherit config nixpkgs home overlays inputs;
      };
    };

    # Default formatter for the entire repo
    formatter = nixpkgs.lib.genAttrs ["x86_64-linux"] (system: pkgs.alejandra);

    sforza = self.nixosConfigurations.sforza.config.system.build.toplevel;

    nixConfig = {
      substituters = [
        #TODO: add more
        "https://cache.nixos.org?priority=10"
      ];
    };
  };
}
