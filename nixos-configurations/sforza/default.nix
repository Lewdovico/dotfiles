{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  # My own modules
  mine = {
    games = {
      gamemode.enable = true;
      lutris.enable = true;
      steam.enable = true;
    };
    gnome = {
      enable = true;
      keyring.enable = true;
      nautilus.enable = true;
    };
    dnscrypt.enable = true;
    fonts.enable = true;
    greetd.enable = true;
    security.enable = true;
    qemu.enable = true;
  };

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend-then-hibernate";
  };

  # OpenGL
  environment.sessionVariables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
      # extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };
  };

  networking = {
    hostName = "sforza";
    useDHCP = lib.mkForce true;
    networkmanager.enable = true;
  };

  # TLP For Laptop
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;
      };
    };
    xserver = {
      layout = "us"; # Configure keymap
      libinput.enable = true;
    };
  };
}
