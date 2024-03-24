{
  lib,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
in {
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  time.timeZone = "Asia/Tokyo";
  programs.command-not-found.enable = false; # Not working without channel

  environment = {
    pathsToLink = ["/share/fish"];
    systemPackages = with nixpkgs; [
      teavpn2
      gnome.adwaita-icon-theme
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
      sbctl # For debugging and troubleshooting Secure boot.

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
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "0";
      NIXPKGS_ALLOW_UNFREE = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "screen-256color";
      BROWSER = "firefox";
      XCURSOR_SIZE = "24";
      DIRENV_LOG_FORMAT = "";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
    };
  };

  programs = {
    dconf.enable = true;
  };

  security = {
    sudo = {
      enable = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never

        # Show asterisk when typing password
        Defaults pwfeedback
      '';
    };

    pam = {
      services.swaylock.text = "auth include login";
    };
  };

  services = {
    # Service that makes Out of Memory Killer more effective
    earlyoom.enable = true;
    dbus.packages = [nixpkgs.gcr];

    # Enable periodic SSD TRIM of mounted partitions in background
    fstrim.enable = true;

    # Location for gammastep
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  nix = {
    nixPath = ["nixpkgs=flake:nixpkgs"]; # https://ayats.org/blog/channels-to-flakes/

    package = inputs.nix-super.packages.${nixpkgs.system}.nix;

    settings = {
      # Prevent impurities in builds
      sandbox = true;

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        # "configurable-impure-env"
        "flakes"
        "no-url-literals"
        "nix-command"
        "parse-toml-timestamps"
        "read-only-local-store"
        "recursive-nix"
      ];

      commit-lockfile-summary = "feat: Update flake.lock";
      accept-flake-config = true;
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;

      # Whether to warn about dirty Git/Mercurial trees.
      warn-dirty = false;

      # Give root user and wheel group special Nix privileges.
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = ["@wheel"];

      substituters = [
        # Lower priority value = higher priority
        "https://cache.nixos.org?priority=1"
        "https://cache.garnix.io?priority=30"
        "https://dotfiles-pkgs.cachix.org?priority=20"
        "https://sforza-config.cachix.org?priority=10"
        "https://nixpkgs-unfree.cachix.org"
        "https://numtide.cachix.org"
        "https://nyx.chaotic.cx/"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "dotfiles-pkgs.cachix.org-1:0TnsAyYE0P2BXv9s7gqqCpkf2SNt4cXKPh/66enbwnk="
        "sforza-config.cachix.org-1:qQiEQ1JU25VqhRXi1Qr/kA8RT01pd7oeKHr5OORUolM="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    registry = {
      system.flake = inputs.nixpkgs;
      default.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };

    # Improve nix store disk usage
    # Disable this because i'm using nh.
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
  };

  system.stateVersion = "23.11";
}