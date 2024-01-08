{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  username,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # FIXME: use non master if https://nixpk.gs/pr-tracker.html?pr=279531 merged
    kernelPackages = lib.mkForce inputs.master.legacyPackages.${pkgs.system}.linuxPackages_latest;
    kernelParams = lib.mkForce [
      "quiet"
      "loglevel=0"
    ];
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "amdgpu"
      "dm-snapshot"
    ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [
      "bcachefs"
      "btrfs"
      "ntfs"
      "xfs"
    ];
  };

  fileSystems =
    let
      inherit username;
      userHome = "/home/${username}";
    in
    {
      "${userHome}/Media" = {
        device = "/dev/disk/by-uuid/9f731a8a-1d76-4b74-ad60-cb2e245d4224";
        fsType = "bcachefs";
        options = [
          # Enable discard/TRIM support
          "discard"
          # foreground compression with zstd
          "compression=zstd"
          # background compression with zstd
          "background_compression=zstd"
        ];
      };

      "${userHome}/WinE" = {
        device = "/dev/disk/by-label/WinE";
        fsType = "ntfs";
        options = [
          "uid=1000"
          "gid=100"
          "rw"
          "user"
          "exec"
          "umask=000"
          "nofail"
        ];
      };

      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=2G"
          "mode=755"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };

      "/nix" = {
        device = "/dev/disk/by-label/Store";
        fsType = "btrfs";
        options = [
          "autodefrag"
          "compress-force=zstd"
          "discard=async"
          "noatime"
          "space_cache=v2"
          "ssd"
        ];
      };

      "/home" = {
        device = "/dev/disk/by-label/Home";
        fsType = "btrfs";
        options = [
          "autodefrag"
          "compress-force=zstd"
          "discard=async"
          "noatime"
          "space_cache=v2"
          "ssd"
        ];
        neededForBoot = true;
      };

      "/persist" = {
        device = "/dev/disk/by-label/Persist";
        fsType = "xfs";
        neededForBoot = true;
      };

      "/etc/nixos" = {
        device = "/persist/etc/nixos";
        fsType = "none";
        options = [ "bind" ];
      };

      "/var/log" = {
        device = "/persist/var/log";
        fsType = "none";
        options = [ "bind" ];
      };
    };

  swapDevices = [ { device = "/dev/disk/by-label/Swap"; } ];

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;

  nix.settings.max-jobs = lib.mkDefault 4;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
