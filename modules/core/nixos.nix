{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true; # ZFS Stuff
  };

  security = {
    # polkit.enable = true;
    sudo.enable = true;
    doas = {
      enable = false;
      extraRules = [
        {
          users = ["ludovico"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;
    dbus.packages = [pkgs.gcr];
  };

  environment = {
    # completion for system packages (e.g. systemd).
    pathsToLink = ["/share/fish"];

    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      teavpn2
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd

      pwvucontrol
      git
      bottom
      jq
      moreutils
      nix-index
      nmap
      skim
      ripgrep
      tealdeer
      whois
      wl-clipboard
      wget
      unzip

      # Utils for nixpkgs stuff
      nixpkgs-review
      # haskellPackages.nixpkgs-update #FIXME: remove comment if fixed upstream
    ];

    sessionVariables = {
      # silence direnv warnings for "long running commands"
      DIRENV_WARN_TIMEOUT = "24h";
      # silence direnv
      DIRENV_LOG_FORMAT = "";
      #   MANGOHUD = "1"; # Launch all vulkan games with mangohud
    };
  };

  nix = {
    nixPath = ["nixpkgs=flake:nixpkgs"]; # https://ayats.org/blog/channels-to-flakes/

    package = inputs.nix-super.packages.${pkgs.system}.nix;

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      auto-optimise-store = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];

      substituters = [
        "https://cache.garnix.io"
        "https://nyx.chaotic.cx"
        "https://sforza-config.cachix.org"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
      ];
    };

    registry = {
      system.flake = inputs.master;
      default.flake = inputs.master;
      nixpkgs.flake = inputs.master;
    };

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes ca-derivations
    '';

    # Improve nix store disk usage
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
  };

  # For rage encryption, all hosts need a ssh key pair
  # services.openssh = {
  #   enable = true;
  #   openFirewall = lib.mkDefault false;
  # };
}
