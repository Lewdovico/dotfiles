{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) fileContents;
in {
  # Sets binary caches which speeds up some builds
  imports = [../cachix];

  environment = {
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      firefox
      git
      bottom
      jq
      manix
      moreutils
      neovim
      nix-index
      nmap
      ripgrep
      skim
      tealdeer
      whois

      inputs.self.packages.${pkgs.system}.multicolor-sddm-theme
    ];
  };

  nix = {
    # Improve nix store disk usage
    gc.automatic = true;

    # Generally useful nix option defaults
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
}
