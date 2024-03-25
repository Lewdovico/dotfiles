{config, ...}: let
  inherit (config.colorScheme) palette;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka q SemiBold-16";
        terminal = "kitty";
        icon-theme = "${config.gtk.iconTheme.name}";
        prompt = "->";
      };

      border = {
        width = 2;
        radius = 0;
      };

      dmenu = {
        mode = "text";
      };

      colors = {
        background = "${palette.base00}f2";
        text = "${palette.base05}ff";
        match = "${palette.base0A}ff";
        selection = "${palette.base03}ff";
        selection-text = "${palette.base05}ff";
        selection-match = "${palette.base0A}ff";
        border = "${palette.base0D}ff";
      };
    };
  };
}
