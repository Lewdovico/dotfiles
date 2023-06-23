{pkgs ? (import ../nixpkgs.nix) {}}: {
  google-sans = pkgs.callPackage ./google-sans {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  multicolor-sddm-theme = pkgs.callPackage ./multicolor-sddm-theme {};
  san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};
  spotify = pkgs.callPackage ./spotify {};
}
