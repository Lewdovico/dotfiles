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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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
