{self, ...}: {
  sops = {
    defaultSopsFile = "${self}/secrets/secrets.yaml";
    age.sshKeyPaths = ["/home/ludovico/.ssh/id_ed25519"];
  };
}
