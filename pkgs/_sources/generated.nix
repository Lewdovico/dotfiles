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
    version = "6703adc37fec45431eaa383a1fe8a4d6893d9b55";
    src = fetchgit {
      url = "https://github.com/alexays/waybar";
      rev = "6703adc37fec45431eaa383a1fe8a4d6893d9b55";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-170cuq5JRVRlxQF3uSs4w6oFQpyU3NaHvY5NvmgBeCY=";
    };
    date = "2024-02-25";
  };
  wezterm = {
    pname = "wezterm";
    version = "95581d8697f3749f84ccb1402ac94ea6582b227f";
    src = fetchgit {
      url = "https://github.com/wez/wezterm";
      rev = "95581d8697f3749f84ccb1402ac94ea6582b227f";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Ygs7y02eMgp/uVpc6YjmNgjC8dS1Phrv62WR5Qp/9g4=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wezterm-95581d8697f3749f84ccb1402ac94ea6582b227f/Cargo.lock;
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
      };
    };
    date = "2024-02-21";
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
