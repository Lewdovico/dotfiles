# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  services.fstrim.enable = true; # SSD

  fileSystems = let
    default = ["rw" "compress=zstd:3" "space_cache=v2" "noatime" "discard=async" "ssd"];
  in {
    "/" = {
      device = "/dev/disk/by-uuid/b2399e88-8c0b-4518-97dc-cb3462cbaeb0";
      fsType = "btrfs";
      options = default ++ ["subvol=root"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/b2399e88-8c0b-4518-97dc-cb3462cbaeb0";
      fsType = "btrfs";
      options = default ++ ["subvol=home"];
      neededForBoot = true;
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/b2399e88-8c0b-4518-97dc-cb3462cbaeb0";
      fsType = "btrfs";
      options = default ++ ["subvol=nix"];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/b2399e88-8c0b-4518-97dc-cb3462cbaeb0";
      fsType = "btrfs";
      options = default ++ ["subvol=persist"];
      neededForBoot = true;
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/b2399e88-8c0b-4518-97dc-cb3462cbaeb0";
      fsType = "btrfs";
      options = default ++ ["subvol=log"];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5FC3-D254";
      fsType = "vfat";
    };
    "/Stuff" = {
      device = "/dev/disk/by-uuid/01D95CE318FF5AE0";
      fsType = "ntfs";
    };
  };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/33494f0f-cf8e-4757-83c0-3b3fb8bda64c";
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/bce65cf1-162a-426e-be84-5fcc822a1f60";
      options = ["rw" "noatime" "discard" "ssd"];
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  #networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
