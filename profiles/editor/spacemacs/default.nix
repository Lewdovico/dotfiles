{
  config,
  pkgs,
  inputs,
  ...
}: let
  gitUrl = "https://github.com";
  spacemacsUrl = "${gitUrl}/syl20bnr/spacemacs";
in {
  home-manager.users."${config.vars.username}" = {
    home.file = {
      ".emacs.d/snippets".source = ./snippets;
      ".spacemacs".source = ./dotSpacemacs;
    };
    programs.emacs = {
      enable = true;
      package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git;
    };
    services.emacs = {
      enable = true;
      package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git;
    };
  };

  system.userActivationScripts = {
    # Installation script every time nixos-rebuild is run. So not during initial install.
    spacemacs = {
      text = ''
        EMACS="$HOME/.emacs.d"

        [ -d $HOME/.emacs.d ] && mv $HOME/.emacs.d $HOME/.emacs.d.bak
        [ -f $HOME/.emacs.el ] && mv $HOME/.emacs.el .emacs.el.bak
        [ -f $HOME/.emacs ] && mv $HOME/.emacs $HOME/.emacs.bak
        [ ! -d "$EMACS" ] && ${pkgs.git}/bin/git clone --depth=1 --single-branch ${spacemacsUrl} $EMACS
      ''; # It will always sync when rebuild is done. So changes will always be applied.
    };
  };

  fonts.fonts = with pkgs; [emacs-all-the-icons-fonts];

  environment.systemPackages = with pkgs; [
    # 28.2 + native-comp
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages
      (epkgs: [epkgs.vterm]))
    inputs.nil.packages.${pkgs.system}.default
    # nodejs-16_x # for copilot
    silver-searcher
    platinum-searcher
    ack
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
