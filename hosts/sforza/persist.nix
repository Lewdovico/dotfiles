{lib, ...}: {
  # Configure LUKS
  # blkid --match-tag UUID --output value "$DISK-part2"
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/1f5e8946-4cac-4eff-af4f-fb96adead7c8";

  # Configure ZFS
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "bbf097da"; # head -c8 /etc/machine-id
  boot.zfs.devNodes = "/dev/vg/root";

  # Roll back to blank snapshot on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  # Persist state
  # environment.etc = {
  #   "nixos".source = "/persist/etc/nixos";
  #   "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
  #   "adjtime".source = "/persist/etc/adjtime";
  #   "NIXOS".source = "/persist/etc/NIXOS";
  # };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/nix"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
}
