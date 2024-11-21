{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  font = {
    name = "SF Pro Rounded";
    size = 11;
  };

  theme = {
    name = "WhiteSur-Dark";
    package = inputs.ludovico-nixpkgs.packages.${pkgs.system}.whitesur-gtk-theme;
  };

  iconsTheme = {
    name = "WhiteSur-dark";
    package = pkgs.whitesur-icon-theme;
  };

  mkService = lib.recursiveUpdate {
    Unit.PartOf = [
      "hyprland-session.target"
      "sway-session.target"
    ];
    Unit.After = [
      "hyprland-session.target"
      "sway-session.target"
    ];
    Install.WantedBy = [
      "hyprland-session.target"
      "sway-session.target"
    ];
  };

  cfg = config.myOptions.theme;
in
{
  options.myOptions.theme = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} =
      { config, ... }:
      let
        # Borrowed from fuf's dotfiles
        apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
          ${lib.optionalString (config.home.sessionPath != [ ]) ''
            export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
          ''}
          ${builtins.concatStringsSep "\n" (
            lib.mapAttrsToList (k: v: ''
              export ${k}=${toString v}
            '') config.home.sessionVariables
          )}
          ${config.home.sessionVariablesExtra}
          exec "$@"
        '';

        # runs processes as systemd transient services
        run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
          exec ${pkgs.systemd}/bin/systemd-run \
            --slice=app-manual.slice \
            --property=ExitType=cgroup \
            --user \
            --wait \
            bash -lc "exec ${apply-hm-env} $@"
        '';
      in
      {
        imports = [
          inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
        ];

        home.packages = [
          run-as-service
        ];

        programs.hyprcursor-phinger.enable = true;

        # User Services
        systemd.user.services = {
          wl-clip-persist = mkService {
            Unit.Description = "Keep Wayland clipboard even after programs close";
            Service = {
              ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
              Restart = "on-failure";
            };
          };
        };

        gtk = {
          enable = true;

          cursorTheme = {
            package = inputs.hyprcursor-phinger.packages.${pkgs.system}.hyprcursor-phinger;
            name = "phinger-cursor-light";
            size = 24;
          };

          gtk2.extraConfig = ''
            gtk-cursor-theme-name="${config.gtk.cursorTheme.name}"
            gtk-cursor-theme-size=${toString config.gtk.cursorTheme.size}
            gtk-toolbar-style=GTK_TOOLBAR_BOTH
            gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
            gtk-button-images=1
            gtk-menu-images=1
            gtk-enable-event-sounds=1
            gtk-enable-input-feedback-sounds=1
            gtk-xft-antialias=1
            gtk-xft-hinting=1
            gtk-xft-hintstyle="hintfull"
            gtk-xft-rgba="rgb"
          '';

          gtk3 = {
            bookmarks = [
              "file://${config.home.homeDirectory}/Code"
              "file://${config.home.homeDirectory}/Media"
              "file://${config.home.homeDirectory}/Documents"
              "file://${config.home.homeDirectory}/Downloads"
              # "file://${config.home.homeDirectory}/Games"
              "file://${config.home.homeDirectory}/Music"
              "file://${config.home.homeDirectory}/Pictures"
              "file://${config.home.homeDirectory}/Videos"
              "file://${config.home.homeDirectory}/WinE"
            ];

            extraConfig = {
              gtk-application-prefer-dark-theme = 1;
              gtk-cursor-theme-name = config.cursorTheme.name;
              gtk-cursor-theme-size = config.cursorTheme.size;
              gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
              gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
              gtk-button-images = 1;
              gtk-menu-images = 1;
              gtk-enable-event-sounds = 1;
              gtk-enable-input-feedback-sounds = 1;
              gtk-xft-antialias = 1;
              gtk-xft-hinting = 1;
              gtk-xft-hintstyle = "hintfull";
              gtk-xft-rgba = "rgb";
            };
          };

          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };

          font = {
            inherit (font) name size;
          };

          theme = {
            inherit (theme) name package;
          };

          iconTheme = {
            inherit (iconsTheme) name package;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
        };

        home.file.".icons/default/index.theme".text = ''
          [icon theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${config.cursorTheme.name}

          [X-GNOME-Metatheme]
          GtkTheme=${theme.name}
          MetacityTheme=${theme.name}
          IconTheme=${iconsTheme.name}
          CursorTheme=${config.cursorTheme.name}
          ButtonLayout=close,minimize,maximize:menu
        '';

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            # Use dconf-editor to get this settings.
            color-scheme = "prefer-dark";
            cursor-theme = config.cursorTheme.name;
            cursor-size = config.cursorTheme.size;
            gtk-theme = theme.name;
            icon-theme = iconsTheme.name;
            font-name = "${font.name} ${toString font.size}";
            clock-format = "12h";
            clock-show-date = true;
            clock-show-seconds = false;
            clock-show-weekday = false;
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "grayscale";
            font-hinting = "slight";
            scaling-factor = 1;
            text-scaling-factor = 1.0;
            toolbar-style = "text";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "close,minimize,maximize:icon";
          };
        };
      }; # For Home-Manager options
  };
}
