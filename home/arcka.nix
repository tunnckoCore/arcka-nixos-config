{ pkgs, ... }:

{
  imports = [
    ./cli-agents.nix
    ./shell.nix
    ./git.nix
    ./bitwarden.nix
    ./browsers.nix
    ./editor.nix
    ./gtk.nix
    ./rofi.nix
    ./terminals.nix
    ./sway.nix
  ];

  home.username = "arcka";
  home.homeDirectory = "/home/arcka";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
    BROWSER = "librewolf";
  };

  home.packages = with pkgs; [
    brave
    bitwarden-cli
    codex
    just
    opencode
  ];

  home.file.".agents/.keep".text = "";

  programs.home-manager.enable = true;
}
