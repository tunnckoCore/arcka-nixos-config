{ pkgs, ... }:

{
  # Keep this mutable for phase 1 so the initial password can be set during
  # install or immediately after first boot instead of storing hashes in git.
  users.mutableUsers = true;

  users.users.arcka = {
    isNormalUser = true;
    description = "arcka";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };
}
