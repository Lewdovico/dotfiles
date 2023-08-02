{
  inputs = {
    # Main Thing
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/release-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # For Webcord
    arrpc = {
      url = "github:NotAShelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-super = {
      url = "github:privatevoid-net/nix-super";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-flake.url = "github:srid/nixos-flake";

    # Non Flakes Stuff
    amoledcord = {
      url = "github:luckfire/amoled-cord";
      flake = false;
    };
  };

  outputs = inputs @ {nixpkgs, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        ./hosts
        ./homes
        ./pkgs

        inputs.devshell.flakeModule
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        system,
        inputs',
        ...
      }: {
        # This sets `pkgs` to a nixpkgs with allowUnfree option set.
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # configure devshell
        devShells.default = let
          devshell = import ./parts/devshell;
        in
          inputs'.devshell.legacyPackages.mkShell {
            name = "Devshell";
            commands = devshell.shellCommands;
            env = devshell.env;
            packages = with pkgs; [
              inputs'.sops-nix.packages.default
              inputs'.nix-super.packages.default
              config.treefmt.build.wrapper
              nil
              alejandra
              git
              statix
              deadnix
            ];
          };

        # configure treefmt
        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
            stylua.enable = true;
            rustfmt.enable = true;
            shfmt.enable = true;
            prettier.enable = true;
          };

          settings.formatter = {
            stylua.options = [
              "--indent-type"
              "spaces"
              "--indent-width"
              "2"
            ];
            prettier = {
              options = ["--write"];
              includes = [
                "*.json"
                "*.yaml"
                "*.md"
              ];
            };
            shfmt.options = [
              "-s"
              "-w"
              "-i"
              "2"
            ];
          };
        };
      };
    };
}
