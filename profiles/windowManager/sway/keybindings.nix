{
  config,
  pkgs,
}: let
  cfg = config.home-manager.users."${config.vars.username}".wayland.windowManager.sway.config;
  mod = cfg.modifier;
  amixer = "${pkgs.alsa-utils}/bin/amixer";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in rec {
  # Kill focused window
  "${mod}+w" = "kill";

  # Reload the configuration file
  "${mod}+Shift+r" = "reload";

  # Wlogout
  "${mod}+x" = "exec wlogout";

  # Exit sway
  "${mod}+Shift+q" = "exit";

  ### Moving around
  # Move your focus around
  "${mod}+h" = "focus left";
  "${mod}+j" = "focus down";
  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";

  # Move the focused window with the same, but add Shift
  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";

  ### Workspaces
  # Switch to workspace
  "${mod}+1" = "workspace 1";
  "${mod}+2" = "workspace 2";
  "${mod}+3" = "workspace 3";
  "${mod}+4" = "workspace 4";
  "${mod}+5" = "workspace 5";
  "${mod}+6" = "workspace 6";
  "${mod}+7" = "workspace 7";
  "${mod}+8" = "workspace 8";
  "${mod}+9" = "workspace 9";

  # Move focused container to workspace
  "${mod}+Shift+1" = "move container to workspace 1";
  "${mod}+Shift+2" = "move container to workspace 2";
  "${mod}+Shift+3" = "move container to workspace 3";
  "${mod}+Shift+4" = "move container to workspace 4";
  "${mod}+Shift+5" = "move container to workspace 5";
  "${mod}+Shift+6" = "move container to workspace 6";
  "${mod}+Shift+7" = "move container to workspace 7";
  "${mod}+Shift+8" = "move container to workspace 8";
  "${mod}+Shift+9" = "move container to workspace 9";

  ### Resizing containers
  "${mod}+r" = "mode resize";
  "${mod}+Left" = "resize shrink width 10px";
  "${mod}+Right" = "resize grow width 10px";
  "${mod}+Down" = "resize shrink height 10px";
  "${mod}+Up" = "resize grow height 10px";

  ### Scratchpad
  # Move the currently focused window to the scratchpad
  "${mod}+Shift+minus" = "move scratchpad";

  # Show the next scratchpad window or hide the focused scratchpad window.
  # If there are multiple scratchpad windows, this command cycles through them.
  "${mod}+minus" = "scratchpad show";

  # Fullscreen
  "${mod}+f" = "fullscreen";

  ### Layout stuff
  "${mod}+c" = "splith";
  "${mod}+v" = "splitv";

  # Switch the current container between different layout styles
  "${mod}+s" = "layout stacking";
  "${mod}+e" = "layout toggle split";
  "${mod}+t" = "layout tabbed";

  # Toggle the current focus between tiling and floating mode
  "${mod}+Space" = "floating toggle";

  ### Apps
  "${mod}+Return" = "exec ${cfg.terminal}";
  "${mod}+p" = "exec run-as-service ${cfg.menu}";
  "${mod}+g" = "exec ${pkgs.firefox}/bin/firefox";
  "${mod}+d" = "exec ${pkgs.discord-canary}/bin/discordcanary";
  "${mod}+Shift+e" = "exec ${pkgs.xfce.thunar}/bin/thunar";

  ### Screenshot
  "Print" = "exec sharenix --selection";
  "${mod}+Print" = "exec grimblast --notify --cursor copysave output ~/Pictures/Screenshots/$(date +'%s.png')";
  "${mod}+Shift+Print" = "exec wl-ocr";
  "CTRL+Print" = "exec grimblast --notify copy area";

  # Volume
  # (un)mute output
  XF86AudioMute = "exec ${amixer} set Master toggle";
  # increase output volume
  XF86AudioRaiseVolume = "exec ${amixer} -q set Master 5%+";
  # decrease output volume
  XF86AudioLowerVolume = "exec ${amixer} -q set Master 5%+";

  # Media control
  XF86AudioPlay = "exec ${playerctl} play-pause";
  XF86AudioNext = "exec ${playerctl} next";
  XF86AudioPrev = "exec ${playerctl} previous";
  XF86AudioStop = "exec ${playerctl} stop";

  # Brightness
  XF86MonBrightnessUp = "exec ${brightnessctl} set 5%+";
  XF86MonBrightnessDown = "exec ${brightnessctl}/bin/brightnessctl set 5%-";
}
