{ pkgs, ... }:

{
  imports = [
    ./cli-agents.nix
    ./shell.nix
    ./xdg.nix
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
    BROWSER = "helium";
    TERMINAL = "kitty";
  };

  home.packages = with pkgs; [
    brave
    bitwarden-cli
    file-roller
  ];

  home.file.".agents/.keep".text = "";
  home.file.".ssh/config".text = ''
    Host localhost
        UserKnownHostsFile /dev/null
  '';
  home.file.".local/bin/disable_lenovo_kb.sh" = {
    executable = true;
    text = ''
      #!/bin/bash

      set -euo pipefail

      KBD_SYS_PATH=$(${pkgs.findutils}/bin/find /sys/devices/platform/i8042 -name "inhibited" | ${pkgs.coreutils}/bin/head -n 1)

      if [ -z "$KBD_SYS_PATH" ]; then
        echo "Could not find the internal keyboard inhibit file."
        exit 1
      fi

      case "''${1:-}" in
        off)
          echo "Disabling internal keyboard..."
          echo 1 | ${pkgs.sudo}/bin/sudo /run/current-system/sw/bin/tee "$KBD_SYS_PATH" > /dev/null
          ;;
        on)
          echo "Enabling internal keyboard..."
          echo 0 | ${pkgs.sudo}/bin/sudo /run/current-system/sw/bin/tee "$KBD_SYS_PATH" > /dev/null
          ;;
        toggle)
          CURRENT_STATE="$(${pkgs.coreutils}/bin/cat "$KBD_SYS_PATH")"
          if [ "$CURRENT_STATE" = "1" ]; then
            echo "Enabling internal keyboard..."
            echo 0 | ${pkgs.sudo}/bin/sudo /run/current-system/sw/bin/tee "$KBD_SYS_PATH" > /dev/null
          else
            echo "Disabling internal keyboard..."
            echo 1 | ${pkgs.sudo}/bin/sudo /run/current-system/sw/bin/tee "$KBD_SYS_PATH" > /dev/null
          fi
          ;;
        *)
          echo "Usage: $0 [on|off|toggle]"
          exit 1
          ;;
      esac
    '';
  };

  programs.home-manager.enable = true;
}
