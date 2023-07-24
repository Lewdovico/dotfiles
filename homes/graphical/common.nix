{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # use OCR and copy to clipboard
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
    _ = lib.getExe;
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';
in {
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home.packages = with pkgs; [
    authy
    tdesktop
    mpv
    mailspring
    imv
    whatsapp-for-linux

    # Qt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    # Utils
    ocrScript
  ];
}
