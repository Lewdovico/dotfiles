{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  _ = lib.getExe;
in
{
  home.packages = with pkgs; [ alsa-utils ];

  programs.waybar = {
    enable = config.wayland.windowManager.hyprland.enable;
    style = ./__style.css;

    # package = pkgs.waybar;
    package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.waybar;

    settings = {
      # Thanks to https://gist.github.com/genofire/07234e810fcd16f9077710d4303f9a9e
      mainBar = {
        "layer" = "top"; # Waybar at top layer
        "position" = "bottom"; # Waybar position (top|bottom|left|right)
        "height" = 18; # Waybar height (to be removed for auto height)

        # Choose the order of the modules
        "modules-left" = [
          "hyprland/workspaces"
          "custom/separator"
          "custom/wireguard"
        ];
        "modules-right" = [
          "custom/disk_home"
          "custom/separator"
          "custom/disk_root"
          "custom/separator"
          # "cpu"
          # "custom/separator"
          # "memory"
          # "custom/separator"
          "network"
          "custom/separator"
          "pulseaudio"
          "custom/separator"
          "clock"
          "custom/separator"
          "battery"
          "custom/separator"
          "idle_inhibitor"
          "custom/separator"
          "tray"
        ];

        # Modules configuration

        "hyprland/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{icon}";
          "show-special" = false;
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e-1";
          "on-scroll-down" = "hyprctl dispatch workspace e+1";
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          "format-icons" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "default" = "󰝥";
            "special" = "󰦥";
          };
        };

        "custom/wireguard" = {
          "format" = "󰖂 Wireguard";
          "exec" = "echo '{\"class\": \"connected\"}'";
          "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
          "return-type" = "json";
          "interval" = 5;
        };

        "custom/separator" = {
          "format" = "|";
          "tooltip" = false;
        };

        "custom/disk_home" = {
          "format" = "󰋊 Porn Folder: {}";
          "interval" = 30;
          "exec" = "df -h --output=avail $HOME | tail -1 | tr -d ' '";
        };
        "custom/disk_root" = {
          "format" = "󰋊 Hentai Folder: {}";
          "interval" = 30;
          "exec" = "df -h --output=avail / | tail -1 | tr -d ' '";
        };
        "cpu" = {
          "format" = "󰻠 {usage}%";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "󰍛 {used:0.1f}G";
        };
        "network" = {
          "format-wifi" = "<span color='#589df6'>󰖩</span> {frequency} <span color='#589df6'>{signaldBm} dB</span> <span color='#589df6'>⇵</span> {bandwidthUpBits}/{bandwidthDownBits}";
          "format-ethernet" = "󰈀 IP Leaked: {ipaddr}/{cidr}";
          "format-linked" = "{ifname} (No IP)";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "interval" = 5;
        };
        "pulseaudio" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-muted" = "󰖁 {format_source}";
          "format-bluetooth" = "{icon}󰂯 {volume}% {format_source}";
          "format-bluetooth-muted" = "󰖁󰂯 {format_source}";

          "format-source" = "󰍬 {volume}%";
          "format-source-muted" = "󰍭";

          "format-icons" = {
            "headphones" = "󰋋";
            "handsfree" = "󱡏";
            "headset" = "󰋋";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          "on-click" = "${_ pkgs.ponymix} -N -t sink toggle";
          "on-click-right" = "${_ pkgs.ponymix} -N -t source toggle";
        };
        "clock" = {
          "interval" = 1;
          "format" = "󰅐 {:%H:%M:%S}";
          "tooltip-format" = "{:%Y-%m-%d | %H:%M:%S}";
        };
        "battery" = {
          "states" = {
            # "good"= 95;
            "warning" = 20;
            "critical" = 10;
          };
          "format" = "<span color='#e88939'>{icon}</span> {capacity}%";
          "format-charging" = "<span color='#e88939'>󰂄</span> {capacity}%";
          "format-plugged" = "<span color='#e88939'>{icon} </span> {capacity}% ({time})";
          "format-icons" = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        "idle_inhibitor" = {
          "format" = "<span color='#589df6'>{icon}</span>";
          "format-icons" = {
            "activated" = "󰈈";
            "deactivated" = "󰈉";
          };
          "on-click-right" = "${_ pkgs.swaylock} -eFfki ${inputs.self}/assets/Minato-Aqua-Dark.png";
        };
        "tray" = {
          # "icon-size"= 21;
          "spacing" = 10;
        };
      };
    };
  };
}
