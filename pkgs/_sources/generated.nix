# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  firefox-gnome-theme = {
    pname = "firefox-gnome-theme";
    version = "4e966509c180f93ba8665cd73cad8456bf44baab";
    src = fetchgit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme";
      rev = "4e966509c180f93ba8665cd73cad8456bf44baab";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-gIBZCPB0sA8Gagrxd8w4+y9uUkWBnXJBmq9Ur5BYTQU=";
    };
    date = "2024-02-26";
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
  swayfx = {
    pname = "swayfx";
    version = "2bd366f3372d6f94f6633e62b7f7b06fcf316943";
    src = fetchgit {
      url = "https://github.com/WillPower3309/swayfx";
      rev = "2bd366f3372d6f94f6633e62b7f7b06fcf316943";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-kRWXQnUkMm5HjlDX9rBq8lowygvbK9+ScAOhiySR3KY=";
    };
    date = "2024-02-15";
  };
  waybar = {
    pname = "waybar";
    version = "2c927de4c624d0c560f73ad78b4abc85fb703562";
    src = fetchgit {
      url = "https://github.com/alexays/waybar";
      rev = "2c927de4c624d0c560f73ad78b4abc85fb703562";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-k6OrkvMDvxpLSXxC4HnuHHcJv/Kr0xm5xdZQYpXlGAI=";
    };
    date = "2024-03-17";
  };
  wezterm = {
    pname = "wezterm";
    version = "889f8a9cd71a2b3552f28f6d1864aa3cd9461fdf";
    src = fetchgit {
      url = "https://github.com/wez/wezterm";
      rev = "889f8a9cd71a2b3552f28f6d1864aa3cd9461fdf";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-H8c7oSJufX2AEgcBk7eMrlFw+x0SgI9vI4iKlNojvMk=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wezterm-889f8a9cd71a2b3552f28f6d1864aa3cd9461fdf/Cargo.lock;
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
      };
    };
    date = "2024-03-16";
  };
  whitesur-gtk-theme = {
    pname = "whitesur-gtk-theme";
    version = "5a52172d2f27437555cc58c7dad15d06af74553d";
    src = fetchgit {
      url = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
      rev = "5a52172d2f27437555cc58c7dad15d06af74553d";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-9HYsORTd5n0jUYmwiObPZ90mOGhR2j+tzs6Y1NNnrn4=";
    };
    date = "2024-02-26";
  };
}
