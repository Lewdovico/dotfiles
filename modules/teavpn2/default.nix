{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.teavpn2;
in {
  options.myOptions.teavpn2 = {
    enable = mkEnableOption "teavpn2";

    configPath = mkOption {
      type = types.path;
      default = config.sops.secrets."teavpnConfig".path;
    };
  };

  config = mkIf cfg.enable {
    systemd.services."teavpn2" = {
      description = "Teavpn2 Service";

      after = ["network.target"];
      requires = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        ${pkgs.teavpn2}/bin/teavpn2 client -c ${cfg.configPath}
      '';

      serviceConfig = {
        User = "root";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
