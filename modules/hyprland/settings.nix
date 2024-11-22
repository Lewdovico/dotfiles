{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  _ = lib.getExe;
  launcher = "${_ pkgs.fuzzel}";
  powermenu = "${_ pkgs.wlogout}";
  emacs = if config.services.emacs.enable then "emacsclient -c" else "emacs";
  inherit (config.colorScheme) palette;
in
{
  exec-once =
    [
      "uwsm finalize"
      "systemctl --user restart xdg-desktop-portal-gtk.service xdg-desktop-portal.service xdg-desktop-portal-hyprland.service"
      "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
      "uwsm app -- waybar"
      "fcitx5 -d --replace"
      "uwsm app -- ${_ pkgs.mako}"
      "[workspace 9 silent;noanim] uwsm app -- ${_ pkgs.thunderbird}"
    ]
    ++ lib.optionals (config.programs.emacs.enable && !config.services.emacs.enable) [
      "${_ config.programs.emacs.finalPackage} --fg-daemon"
    ];

  env = [
    "HYPRCURSOR_SIZE,${toString config.gtk.cursorTheme.size}"
    "HYPRCURSOR_THEME,${config.gtk.cursorTheme.name}"
  ];

  monitor = [
    ",highrr,auto,1"
    "HDMI-A-1, highrr, auto, 1.5"
  ];

  animations = {
    enabled = true;

    bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "windowsMove, 1, 2, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    force_split = 2;
    pseudotile = true;
    preserve_split = true;
  };

  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    rounding = 0;

    dim_inactive = false;
    dim_strength = 0.7;

    blur = {
      enabled = false;
      size = 2;
      passes = 2;
      # contrast = 0.8916;
      # brightness = 0.8172;
      vibrancy = 0.4;
      new_optimizations = true;
      ignore_opacity = true;
      xray = true;
      special = true;
    };

    shadow = {
      enabled = false;
      range = 8;
      render_power = 3;
    };
  };

  general = {
    gaps_in = 3;
    gaps_out = 3;
    border_size = 2;
    "col.active_border" = "rgb(${palette.base0D})";
    "col.inactive_border" = "rgb(${palette.base03})";

    layout = "dwindle";
  };

  group = {
    groupbar = {
      render_titles = false;
      text_color = "rgb(${palette.base05})";
      "col.active" = "rgb(${palette.base0D})";
      "col.inactive" = "rgb(${palette.base03})";
    };
    "col.border_active" = "rgb(${palette.base0D})";
    "col.border_inactive" = "rgb(${palette.base03})";
  };
  misc.background_color = "rgb(${palette.base00})";

  input = {
    kb_layout = "us";
    follow_mouse = 1;
    repeat_rate = 30;
    repeat_delay = 300;
    kb_options = "ctrl:nocaps";

    touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
    };
  };

  misc = {
    disable_splash_rendering = true; # Text below the wallpaper
    force_default_wallpaper = false;
    vfr = true;
    vrr = 0;
  };

  layerrule = [
    "blur, notifications"
    "blur, launcher"
    "blur, lockscreen"
    "ignorealpha 0.69, notifications"
    "ignorealpha 0.69, launcher"
    "ignorealpha 0.69, lockscreen"
  ];

  workspace = [
    "w[tv1], gapsout:0, gapsin:0"
    "f[1], gapsout:0, gapsin:0"
  ];

  windowrulev2 = [
    "bordersize 0, floating:0, onworkspace:w[tv1]"
    "rounding 0, floating:0, onworkspace:w[tv1]"
    "bordersize 0, floating:0, onworkspace:f[1]"
    "rounding 0, floating:0, onworkspace:f[1]"
    "workspace 9, class:^(thunderbird)$"
    "workspace 8, class:^(whatsapp-for-linux)$"
    "workspace 7, class:^(qBittorrent|org.qbittorrent.qBittorrent)$"
    "workspace 6, class:^(steam)$"
    "workspace 6, title:^(Sign in to Steam)$"
    "workspace 5, title:(Spotify)"
    "workspace 4, class:^(org.telegram.desktop)$"
    "workspace 3, title:^(.*(Disc|ArmC|WebC)ord.*)$"
    "workspace 3, class:^(vesktop)$"
    "workspace 2, class:^(firefox)$"
    "workspace 2, class:^(floorp)$"
    "workspace 2, class:^(Chromium-browser)$" # xwayland
    "workspace 2, class:^(chromium-browser)$" # wayland
    "workspace 1, class:^(jetbrains-goland)$"
    "workspace 1, class:^(jetbrains-clion)$"
    "workspace 1, class:^(Albion-Online)$"
    "float, title:^(Steam - News)$"
    "float, class:^(xdg-desktop-portal-gtk)$,title:^(Open Files)$"
    "float, class:^(steam)$,title:^(Special Offers)$"
    "noblur, class:^(waybar)$"
    "noblur, class:^(firefox)$"
    "noblur, class:^(floorp)$"
    "noblur, class:^(Chromium-browser)$" # xwayland
    "noblur, class:^(chromium-browser)$" # wayland
    "noblur, title:^(.*(Disc|WebC)ord.*)$"
    "noblur, title:^(Open File)$"
    "noshadow, class:^(firefox)$"
    "noshadow, class:^(floorp)$"
    "noshadow, class:^(Chromium-browser)$" # xwayland
    "noshadow, class:^(chromium-browser)$" # wayland
    "noshadow, title:^(.*(Disc|WebC)ord.*)$"
    "noanim, class:^(org.telegram.desktop)$"
    "noanim, class:^(wlogout)$"
  ];

  "$mod" = "SUPER";
  bind = [
    "$mod SHIFT, C , exit ,"
    "$mod      , Q, togglespecialworkspace"
    "$mod SHIFT, Q, movetoworkspace, special"
    "$mod      , D , exec , uwsm app -- vesktop"
    "$mod SHIFT, E , exec , uwsm app -- thunar"
    "$mod      , F , fullscreen , 0"
    "$mod      , G , exec , uwsm app -- firefox"
    "$mod SHIFT, G , exec , uwsm app -- chromium"
    "$mod      , M , exec , [workspace 9 silent;tile] uwsm app --  thunderbird"
    "$mod      , P , exec , uwsm app -- ${launcher}"
    "$mod SHIFT, P , exec , uwsm app -- ${lib.getExe' pkgs.pass-wayland "passmenu"}"
    "$mod      , Space , togglefloating ,"
    "$mod      , R , togglegroup ,"
    "$mod SHIFT, J , changegroupactive, f"
    "$mod SHIFT, K , changegroupactive, b"
    "$mod      , S , exec , uwsm app -- spotify"
    "$mod      , W , killactive ,"
    "$mod      , X , exec , ${powermenu}"
    "$mod      , Return , exec , uwsm app -- '${osConfig.myOptions.vars.terminal}'"

    "$mod      , E , exec , uwsm app -- \"${emacs}\""
    "ALT       , E , exec , uwsm app -- \"emacsclient -c -eval '(dired nil)'\""

    ", print, exec , uwsm app --  wl-ocr"
    "CTRL   , Print , exec , uwsm app -- ${_ pkgs.grimblast} save area - | ${_ pkgs.swappy} -f -"
    "ALT    , Print , exec , uwsm app -- ${_ pkgs.grimblast} --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%s.png')"

    # Dwindle Keybind
    "$mod , h , resizeactive , -20 0"
    "$mod , l , resizeactive , 20 0"
    "$mod , k , movefocus , u"
    "$mod , j , movefocus , d"

    "$mod , left , movewindow , l"
    "$mod , right , movewindow , r"
    "$mod , up , movewindow , u"
    "$mod , down , movewindow , d"
    "$mod SHIFT , h , movewindow , l"
    "$mod SHIFT , l , movewindow , r"
    "$mod SHIFT , k , movewindow , u"
    "$mod SHIFT , j , movewindow , d"

    "$mod , 1 , workspace , 1"
    "$mod , 2 , workspace , 2"
    "$mod , 3 , workspace , 3"
    "$mod , 4 , workspace , 4"
    "$mod , 5 , workspace , 5"
    "$mod , 6 , workspace , 6"
    "$mod , 7 , workspace , 7"
    "$mod , 8 , workspace , 8"
    "$mod , 9 , workspace , 9"
    "$mod , 0 , workspace , 10"

    "$mod SHIFT , 1 , movetoworkspacesilent , 1"
    "$mod SHIFT , 2 , movetoworkspacesilent , 2"
    "$mod SHIFT , 3 , movetoworkspacesilent , 3"
    "$mod SHIFT , 4 , movetoworkspacesilent , 4"
    "$mod SHIFT , 5 , movetoworkspacesilent , 5"
    "$mod SHIFT , 6 , movetoworkspacesilent , 6"
    "$mod SHIFT , 7 , movetoworkspacesilent , 7"
    "$mod SHIFT , 8 , movetoworkspacesilent , 8"
    "$mod SHIFT , 9 , movetoworkspacesilent , 9"
    "$mod SHIFT , 0 , movetoworkspacesilent , 10"

    ", XF86AudioNext , exec , ${pkgs.playerctl}/bin/playerctl next"
    ", XF86AudioPrev , exec , ${pkgs.playerctl}/bin/playerctl previous"
    ", XF86AudioPlay , exec , ${pkgs.playerctl}/bin/playerctl play-pause"
    ", XF86AudioPause , exec , ${pkgs.playerctl}/bin/playerctl pause"
    ", XF86AudioStop , exec , ${pkgs.playerctl}/bin/playerctl stop"
  ];

  binde = [
    ", XF86AudioRaiseVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%+"
    ", XF86AudioLowerVolume , exec , ${pkgs.alsa-utils}/bin/amixer -q set Master 5%-"

    ", XF86MonBrightnessUp , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
    ", XF86MonBrightnessDown , exec , ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
  ];

  bindm = [
    "$mod , mouse:272 , movewindow"
    "$mod , mouse:273 , resizewindow"
  ];

  xwayland.force_zero_scaling = true;
}
