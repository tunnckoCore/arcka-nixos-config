{ ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      user.name = "tunnckoCore";
      user.email = "5038030+tunnckoCore@users.noreply.github.com";
      user.signingkey = "~/id_charlike_nistp256_tpm2.pub";
      push.autoSetupRemote = true;
    };
  };
}
