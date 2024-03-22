{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    diff-so-fancy = {
      enable = true;
    };

    userEmail = "lewdovico@gnuweeb.org";
    userName = "Ludovico Piero";

    signing = {
      key = "3911DD276CFE779C";
      signByDefault = true;
    };

    extraConfig = {
      color = {
        ui = true;
        diff-highlight.oldNormal = "red bold";
        diff-highlight.oldHighlight = "red bold 52";
        diff-highlight.newNormal = "green bold";
        diff-highlight.newHighlight = "green bold 22";
        diff.meta = "11";
        diff.frag = "magenta bold";
        diff.func = "146 bold";
        diff.commit = "yellow bold";
        diff.old = "red bold";
        diff.new = "green bold";
        diff.whitespace = "red reverse";
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      format.signOff = "yes";

      sendemail = {
        smtpencryption = "tls";
        smtpserver = "mail1.gnuweeb.org";
        smtpuser = "lewdovico@gnuweeb.org";
        smtpserverport = 587;
        # smtpPass = ""; #TODO: agenix(?)
      };
    };

    ignores = [
      "*~"
      "*.swp"
      "*result*"
      ".direnv"
      "node_modules"
      "tmp"
    ];

    aliases = {
      a = "add -p";
      co = "checkout";
      cob = "checkout -b";
      f = "fetch -p";
      c = "commit -s -v";
      cl = "clone";
      ba = "branch -a";
      bd = "branch -d";
      bD = "branch -D";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      r = "restore";
      rs = "restore --staged";
      s = "status";
      st = "status -sb";
      p = "push";
      pl = "pull";

      # reset
      soft = "reset --soft";
      hard = "reset --hard";
      s1ft = "soft HEAD~1";
      h1rd = "hard HEAD~1";

      # logging
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
      tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
      rank = "shortlog -sn --no-merges";

      # delete merged branches
      bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
    };
  };
}
