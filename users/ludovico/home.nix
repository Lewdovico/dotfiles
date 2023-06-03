{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  imports = [
    ../shared/home.nix

    ../../modules/home-manager/emacs
  ];

  colorscheme = {
    slug = "Skeet";
    name = "Skeet";
    author = "Ludovico";
    colors =
      inputs.nix-colors.colorSchemes.catppuccin-mocha.colors
      // {
        blue = "1e5799";
        pink = "f300ff";
        yellow = "e0ff00";
        gray = "595959";
      };
  };

  fonts.fontconfig.enable = true;

  lv.emacs.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "24";
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # with ungoogled, you can't install extensions from the settings below
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
        }
        {
          id = "ilcacnomdmddpohoakmgcboiehclpkmj";
          updateUrl = "https://raw.githubusercontent.com/FastForwardTeam/releases/main/update/update.xml";
        }
      ];
    };

    obs-studio = {
      enable = true;
      plugins = with inputs.nixpkgs-wayland.packages.${system}; [obs-wlrobs];
    };

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;

      coc = {
        enable = true;
        settings = {
          # Disable coc suggestion
          definitions.languageserver.enable = false;
          suggest.autoTrigger = "none";

          # :CocInstall coc-discord-rpc
          # coc-discord-rpc
          rpc = {
            checkIdle = false;
            detailsViewing = "In {workspace_folder}";
            detailsEditing = "{workspace_folder}";
            lowerDetailsEditing = "Working on {file_name}";
          };
          # ...
        };
      };

      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        vim-nix
        plenary-nvim
        dashboard-nvim
        lualine-nvim
        nvim-tree-lua
        bufferline-nvim
        nvim-colorizer-lua
        impatient-nvim
        telescope-nvim
        indent-blankline-nvim
        # nvim-treesitter
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-css
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-scss
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-yaml
          ]))
        comment-nvim
        vim-fugitive
        nvim-web-devicons
        lsp-format-nvim
        which-key-nvim

        gitsigns-nvim
        neogit

        # Cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-cmp
        nvim-lspconfig
        luasnip
        cmp_luasnip
      ];

      extraPackages = with pkgs; [
        alejandra
        lua-language-server
        stylua # Lua
        rust-analyzer
        gcc
        (ripgrep.override {withPCRE2 = true;})
        fd
      ];

      # https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix#L41
      extraConfig = let
        luaRequire = module:
          builtins.readFile (builtins.toString
            ./config/neovim/lua
            + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
          "cmp"
          # "copilot"
          "colorizer"
          "keybind"
          "settings"
          "theme"
          "ui"
          "which-key"
        ]);
      in ''
        set guicursor=n-v-c-i:block
        lua << EOF
        ${luaConfig}
        EOF
      '';
    };

    spicetify = let
      spicePkgs = inputs.spicetify.packages.${system}.default;
    in {
      enable = true;
      spotifyPackage = pkgs.spotify;
      theme = spicePkgs.themes.catppuccin-mocha;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        adblock
      ];

      # enabledCustomApps = ["marketplace"];
    };

    foot = {
      enable = true;
      settings = import ./config/foot.nix {
        inherit (config) colorscheme;
      };
    };

    # wezterm = {
    #   enable = true;
    #   colorSchemes = import ./config/wezterm/colorscheme.nix {
    #     inherit (config) colorscheme;
    #   };
    #   extraConfig = import ./config/wezterm/config.nix {
    #     inherit (config) colorscheme;
    #   };
    # };

    fuzzel = {
      enable = true;
      settings = import ./config/fuzzel.nix {
        inherit (config) colorscheme;
        inherit config;
      };
    };

    tmux = {
      enable = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      extraConfig = import ./config/tmux.nix;
      plugins = [
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_left_separator "█"
            set -g @catppuccin_right_separator "█"
            set -g @catppuccin_date_time "%Y-%m-%d %H:%M"
          '';
        }
      ];
    };

    firefox = {
      enable = true;

      profiles.ludovico =
        {
          isDefault = true;
          name = "Ludovico";
          extensions = with config.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            grammarly
          ];
          bookmarks = import ./config/firefox/bookmarks.nix;
          search = import ./config/firefox/search.nix {inherit pkgs;};
          settings = import ./config/firefox/settings.nix;
        }
        // (let
          inherit (config.nur.repos.federicoschonborn) firefox-gnome-theme;
        in {
          userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
          userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
          extraConfig = builtins.readFile "${firefox-gnome-theme}/configuration/user.js";
        });
    };

    waybar = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
      settings = import ./config/waybar/settings.nix {
        inherit pkgs;
        inherit lib;
      };
      style = import ./config/waybar/style.nix {inherit (config) colorscheme;};
    };
  };

  services = {
    dunst = {
      enable = true;
      package = inputs.nixpkgs-wayland.packages.${system}.dunst;

      iconTheme = {
        name = "Papirus";
        size = "32x32";
        package = pkgs.papirus-icon-theme;
      };

      settings = import ./config/dunst.nix {inherit (config) colorscheme;};
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemdIntegration = true;
    recommendedEnvironment = true;

    extraConfig = import ./config/hyprland.nix {
      inherit (config) colorscheme;
      inherit pkgs;
      inherit lib;
      inherit config;
    };
  };

  xdg = {
    configFile."MangoHud/MangoHud.conf".text = ''
      gpu_stats
      cpu_stats
      fps
      frame_timing = 0
      throttling_status = 0
      position=top-right
    '';
    userDirs = {
      enable = true;
    };
  };

  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Images Wallpaper Daemon";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${../../assets/wallpaper/wolf.jpeg}";
        Restart = "on-failure";
      };
    };
    # mpvpaper = mkService {
    #   Unit.Description = "Video Wallpaper Daemon";
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs.mpvpaper} -o \"no-audio --loop-playlist shuffle\" eDP-1 ${../../assets/wallpaper/wallpaper.mp4}";
    #     Restart = "on-failure";
    #   };
    # };
    cliphist = mkService {
      Unit.Description = "Clipboard History";
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
      };
    };
  };

  programs.home-manager.enable = true;
}
