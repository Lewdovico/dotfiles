{
  config,
  pkgs,
  inputs,
  ...
}: let
  gitUrl = "https://github.com";
  doomUrl = "${gitUrl}/doomemacs/doomemacs";
  configUrl = "${gitUrl}/lewdovico/doom.d";
in {
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacsPgtk;
  };

  system.userActivationScripts = {
    # Installation script every time nixos-rebuild is run. So not during initial install.
    doomEmacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        EMACS="$HOME/.emacs.d"

        if [ ! -d "$EMACS" ]; then
          ${pkgs.git}/bin/git clone --depth=1 --single-branch ${doomUrl} $EMACS
          yes | $EMACS/bin/doom install
          rm -r $HOME/.doom.d
          ${pkgs.git}/bin/git clone ${configUrl} $HOME/.doom.d
          $EMACS/bin/doom sync
        else
          $EMACS/bin/doom sync
        fi
      ''; # It will always sync when rebuild is done. So changes will always be applied.
    };
  };

  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];

  environment.systemPackages = with pkgs; [
    # 28.2 + native-comp
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages
      (epkgs: [epkgs.vterm]))
    inputs.nil.packages.${pkgs.system}.default
    nodejs-16_x # for copilot
    lua-language-server
    stylua # Lua
    rust-analyzer
    alejandra
    (ripgrep.override {withPCRE2 = true;})
    coreutils
    fd
    #git
  ]; # Dependencies
}
