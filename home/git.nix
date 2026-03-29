{ ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      gpg.format = "ssh";
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/tpm2ssh/id_arcka_nistp256_tpm2.pub";
    };
  };
}
