{ lib, pkgs, theme, ... }:

let
  # Mod1 is Alt in Sway/i3 terminology.
  modifier = "Mod1";
  rofiLenovoKeyboard = pkgs.writeShellApplication {
    name = "rofi-lenovo-kb";
    runtimeInputs = [ pkgs.findutils pkgs.coreutils pkgs.sudo ];
    text = ''
      set -eu

      kbd_sys_path="$(find /sys/devices/platform/i8042 -name inhibited | head -n 1)"
      [ -n "''$kbd_sys_path" ] || exit 1

      current="$(cat "''$kbd_sys_path")"
      if [ "''$current" = "1" ]; then
        next="0"
      else
        next="1"
      fi

      printf '%s\n' "''$next" | sudo tee "''$kbd_sys_path" >/dev/null
    '';
  };
  rofiNetwork = pkgs.writeShellApplication {
    name = "rofi-network";
    runtimeInputs = [ pkgs.networkmanager pkgs.rofi-wayland ];
    text = ''
      set -eu

      selection="$(${pkgs.networkmanager}/bin/nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL device wifi list --rescan yes \
        | awk -F: '{ if ($2 != "") printf("%s %s (%s%%)\n", ($1 == "*" ? "*" : " "), $2, $4); }' \
        | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p 'WiFi')"
      [ -n "''$selection" ] || exit 0

      ssid="$(printf '%s' "''$selection" | sed 's/^[* ] //' | sed 's/ ([0-9]\+%)$//')"
      [ -n "''$ssid" ] || exit 1

      if ${pkgs.networkmanager}/bin/nmcli connection up "''$ssid" >/dev/null 2>&1; then
        exit 0
      fi

      password="$(printf "" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -password -p "Password for ''$ssid")"
      [ -n "''$password" ] || exit 1
      ${pkgs.networkmanager}/bin/nmcli device wifi connect "''$ssid" password "''$password"
    '';
  };
in {
  home.packages = [ rofiLenovoKeyboard rofiNetwork ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.variables = [ "--all" ];
    config = {
      inherit modifier;
      terminal = "alacritty";
      menu = "rofi -show drun";
      bars = [];
      focus.followMouse = false;
      gaps.inner = 8;
      gaps.outer = 4;
      input."type:keyboard" = {
        xkb_layout = "us,bg";
        xkb_variant = ",phonetic";
        xkb_options = "grp:alt_shift_toggle";
      };
      startup = [
        { command = "dbus-update-activation-environment --systemd --all"; }
        { command = "nm-applet --indicator"; }
      ];
      keybindings = lib.mkOptionDefault {
        "Control+space" = "exec rofi -show drun";
        "${modifier}+Return" = "exec alacritty";
        "${modifier}+Shift+Return" = "exec ghostty";
        "${modifier}+b" = "exec librewolf";
        "${modifier}+Shift+b" = "exec brave";
        "${modifier}+f" = "exec thunar";
        "${modifier}+e" = "exec zeditor";
        "${modifier}+d" = "exec rofi -show drun";
        "${modifier}+w" = "exec rofi-network";
        "${modifier}+Shift+w" = "exec rofi-lenovo-kb";
        "${modifier}+p" = "exec rofi-bitwarden";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
      };
      workspaceAutoBackAndForth = true;
    };
    extraConfig = ''
      include /etc/sway/config.d/*
      default_border pixel 1
      default_border pixel 2
      gaps inner 10
      gaps outer 6
      client.focused #${theme.blue} #${theme.blue} #${theme.base} #${theme.blue} #${theme.blue}
      client.unfocused #${theme.surface0} #${theme.surface0} #${theme.text} #${theme.surface0} #${theme.surface0}
      client.urgent #${theme.red} #${theme.red} #${theme.base} #${theme.red} #${theme.red}
      bindsym ${modifier}+1 workspace number 1
      bindsym ${modifier}+2 workspace number 2
      bindsym ${modifier}+3 workspace number 3
      bindsym ${modifier}+4 workspace number 4
      bindsym ${modifier}+5 workspace number 5
      bindsym ${modifier}+6 workspace number 6
      bindsym ${modifier}+7 workspace number 7
      bindsym ${modifier}+8 workspace number 8
      bindsym ${modifier}+9 workspace number 9
      bindsym ${modifier}+Shift+1 move container to workspace number 1
      bindsym ${modifier}+Shift+2 move container to workspace number 2
      bindsym ${modifier}+Shift+3 move container to workspace number 3
      bindsym ${modifier}+Shift+4 move container to workspace number 4
      bindsym ${modifier}+Shift+5 move container to workspace number 5
      bindsym ${modifier}+Shift+6 move container to workspace number 6
      bindsym ${modifier}+Shift+7 move container to workspace number 7
      bindsym ${modifier}+Shift+8 move container to workspace number 8
      bindsym ${modifier}+Shift+9 move container to workspace number 9
    '';
  };

}
