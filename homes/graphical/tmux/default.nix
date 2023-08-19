{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-a";
    terminal = "screen-256color";
    mouse = true;

    extraConfig = ''
      bind -n M-H previous-window
      bind -n M-L next-window

      # Set vi-mode
      set-window-option -g mode-keys vi

      # Open panes in current working directory
      bind ';' split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"
    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = mkTmuxPlugin {
          pluginName = "sensible";
          version = "unstable-2017-09-05";
          src = pkgs.fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-sensible";
            rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
            hash = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
          };
        };
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = "vim-tmux-navigator";
          rtpFilePath = "vim-tmux-navigator.tmux";
          version = "unstable-2022-08-21";
          src = pkgs.fetchFromGitHub {
            owner = "christoomey";
            repo = "vim-tmux-navigator";
            rev = "cdd66d6a37d991bba7997d593586fc51a5b37aa8";
            hash = "sha256-gF1b5aBQTNQm2hCY5aR+RSU4cCNG356Yg6uPnlgqS4o=";
          };
        };
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = "dracula";
          version = "unstable-2023-08-20";
          src = pkgs.fetchFromGitHub {
            owner = "ludovicopiero";
            repo = "tmux";
            rev = "c21c80055b3ea1b69049ffaa38853d5166535b83";
            hash = "sha256-DxJTj2VquDS0y19fvTy7TK8k5fT+ggpv40MaiJhs+5E=";
          };
        };
        extraConfig = ''
          # Dracula Theme
          set -g status-position top
        '';
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = "yank";
          version = "unstable-2023-07-24";
          src = pkgs.fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-yank";
            rev = "acfd36e4fcba99f8310a7dfb432111c242fe7392";
            hash = "sha256-/5HPaoOx2U2d8lZZJo5dKmemu6hKgHJYq23hxkddXpA=";
          };
        };
        extraConfig = ''
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];
  };
}
