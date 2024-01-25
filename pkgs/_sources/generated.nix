# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  firefox-gnome-theme = {
    pname = "firefox-gnome-theme";
    version = "ba893aec06b8be8b8dbe33332ef631735e5ecc5c";
    src = fetchgit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme";
      rev = "ba893aec06b8be8b8dbe33332ef631735e5ecc5c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-VDm5zOGMWOW1DUHUp+TcK9GxfUSy3y1I/3a13Dr9QN8=";
    };
    date = "2024-01-25";
  };
  san-francisco-pro = {
    pname = "san-francisco-pro";
    version = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
    src = fetchgit {
      url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
      rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
    };
    date = "2021-06-22";
  };
  waybar = {
    pname = "waybar";
    version = "5f115785cf94599a57e5d396e71b3f6f85d56cfd";
    src = fetchgit {
      url = "https://github.com/alexays/waybar";
      rev = "5f115785cf94599a57e5d396e71b3f6f85d56cfd";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-yjA2vPca3X3ku50L8zrShPdBAnCKQmdfgw/U/IJFKEo=";
    };
    date = "2024-01-25";
  };
  wezterm = {
    pname = "wezterm";
    version = "1f9f3f2a5d3a594d1a70d5d443defc65c94c5ccb";
    src = fetchgit {
      url = "https://github.com/wez/wezterm";
      rev = "1f9f3f2a5d3a594d1a70d5d443defc65c94c5ccb";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-xKuT/8vXpClNqlPI5NKre+FBVrbe03BT/t22Kn5GKNo=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wezterm-1f9f3f2a5d3a594d1a70d5d443defc65c94c5ccb/Cargo.lock;
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
      };
    };
    date = "2024-01-25";
  };
}
