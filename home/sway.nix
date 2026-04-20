{ config, pkgs, theme, ... }:

let
  # Mod1 is Alt in Sway/i3 terminology.
  modifier = "Mod1";
  secondaryModifier = "Ctrl";
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
  swayWindowToggle = pkgs.writeShellApplication {
    name = "sway-window-toggle";
    runtimeInputs = [ pkgs.jq pkgs.sway ];
    text = ''
      set -eu

      tree="$(${pkgs.sway}/bin/swaymsg -t get_tree)"

      IFS=$'\t' read -r next_workspace_name next_window_id <<EOF
      $(${pkgs.jq}/bin/jq -r '
        def nodes_recursive: recurse(.nodes[]?, .floating_nodes[]?);
        def leaf_windows($workspace):
          $workspace
          | nodes_recursive
          | select(.type == "con" and ((.nodes | length) == 0) and ((.floating_nodes | length) == 0));

        first(.nodes[] | select(.type == "output" and .active == true)) as $output
        | [
            $output.nodes[]
            | select(.type == "workspace" and (((.nodes | length) + (.floating_nodes | length)) > 0))
            | . as $workspace
            | leaf_windows($workspace)
            | {
                workspace: $workspace.name,
                workspace_num: (if $workspace.num == null then 999999 else $workspace.num end),
                id,
                focused,
                x: .rect.x,
                y: .rect.y
              }
          ]
        | sort_by(.workspace_num, .workspace, .y, .x, .id) as $windows
        | if ($windows | length) < 2 then
            empty
          else
            ([ $windows[].focused ] | index(true)) as $current_index
            | if $current_index == null then
                empty
              else
                $windows[(($current_index + 1) % ($windows | length))] as $next
                | "\($next.workspace)\t\($next.id)"
              end
          end
      ' <<<"''$tree")
      EOF

      [ -n "''$next_workspace_name" ] || exit 0

      if [ -n "''$next_window_id" ]; then
        exec ${pkgs.sway}/bin/swaymsg "workspace \"''$next_workspace_name\"; [con_id=''$next_window_id] focus"
      fi

      exec ${pkgs.sway}/bin/swaymsg "workspace \"''$next_workspace_name\""
    '';
  };
  swayStatus = pkgs.writeShellApplication {
    name = "sway-status";
    runtimeInputs = [ pkgs.coreutils pkgs.jq pkgs.wireplumber ];
    text = ''
      volume_json() {
        local state volume pct icon whole frac
        state="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true)"

        if [[ "$state" =~ Volume:[[:space:]]+([0-9.]+) ]]; then
          volume="''${BASH_REMATCH[1]}"
        else
          volume="0"
        fi

        whole="''${volume%%.*}"
        frac="''${volume#*.}"
        if [ "$frac" = "$volume" ]; then
          frac="0"
        fi
        frac="''${frac}00"
        pct="$((10#$whole * 100 + 10#''${frac:0:2}))"

        if [[ "$state" == *"[MUTED]"* ]]; then
          icon="󰝟"
        elif [ "$pct" -lt 35 ]; then
          icon="󰕿"
        elif [ "$pct" -lt 70 ]; then
          icon="󰖀"
          elif [ "$pct" -lt 90 ]; then
          icon="󰕾"
        fi

        printf '{"name":"volume","full_text":"%s %s%%"}' "$icon" "$pct"
      }

      cat <<'EOF'
      {"version":1}
      [
      []
      EOF

      while true; do
        printf ',[%s,{"full_text":"%s"}]\n' \
          "$(volume_json)" \
          "$(date '+%a, %B %d, %H:%M')"
        sleep 1
      done
    '';
  };
in {
  home.packages = [ rofiNetwork swayWindowToggle swayStatus ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.variables = [ "--all" ];
    config = {
      inherit modifier;
      terminal = "kitty";
      menu = "rofi -show drun";
      bars = [
        {
          mode = "dock";
          position = "bottom";
          hiddenState = "show";
          statusCommand = "sway-status";
          workspaceButtons = true;
          workspaceNumbers = true;
          fonts = {
            names = [ theme.font.sans theme.font.mono ];
            size = 12.0;
          };
          colors = {
            background = "#${theme.base}";
            statusline = "#${theme.text}";
            separator = "#${theme.surface1}";
            focusedWorkspace = {
              border = "#${theme.blue}";
              background = "#${theme.blue}";
              text = "#${theme.base}";
            };
            activeWorkspace = {
              border = "#${theme.surface1}";
              background = "#${theme.surface0}";
              text = "#${theme.text}";
            };
            inactiveWorkspace = {
              border = "#${theme.surface1}";
              background = "#${theme.surface0}";
              text = "#${theme.subtext0}";
            };
            urgentWorkspace = {
              border = "#${theme.red}";
              background = "#${theme.red}";
              text = "#${theme.base}";
            };
          };
        }
      ];
      focus.followMouse = true;
      window = {
        titlebar = false;
        border = 0;
        hideEdgeBorders = "none";
      };
      floating = {
        titlebar = false;
        border = 0;
      };
      gaps = {
        inner = 0;
        outer = 0;
        smartGaps = false;
        smartBorders = "off";
      };
      colors = {
        focused = {
          border = "#${theme.blue}";
          background = "#${theme.blue}";
          text = "#${theme.base}";
          indicator = "#${theme.blue}";
          childBorder = "#${theme.blue}";
        };
        focusedInactive = {
          border = "#${theme.surface0}";
          background = "#${theme.surface0}";
          text = "#${theme.text}";
          indicator = "#${theme.surface0}";
          childBorder = "#${theme.surface0}";
        };
        unfocused = {
          border = "#${theme.surface0}";
          background = "#${theme.surface0}";
          text = "#${theme.text}";
          indicator = "#${theme.surface0}";
          childBorder = "#${theme.surface0}";
        };
        urgent = {
          border = "#${theme.red}";
          background = "#${theme.red}";
          text = "#${theme.base}";
          indicator = "#${theme.red}";
          childBorder = "#${theme.red}";
        };
        background = "#${theme.base}";
      };
      input."type:keyboard" = {
        xkb_layout = "us,bg";
        xkb_variant = ",phonetic";
        xkb_options = "grp:alt_shift_toggle";
        xkb_numlock = "enabled";
      };
      startup = [
        { command = "dbus-update-activation-environment --systemd --all"; }
        { command = "nm-applet --indicator"; }
        {
          command = "swaymsg 'gaps inner all set 0; gaps outer all set 0'";
          always = true;
        }
        {
          command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
          always = true;
        }
      ];
      keybindings = {
        "${modifier}+space" = "exec rofi -show drun";
        "${modifier}+Tab" = "exec sway-window-toggle";
        "${modifier}+grave" = "exec sway-window-toggle";
        "${modifier}+asciitilde" = "exec sway-window-toggle";
        "${modifier}+dead_tilde" = "exec sway-window-toggle";
        "${modifier}+Shift+Tab" = null;
        "${modifier}+1" = "workspace number '1 web'";
        "${modifier}+2" = "workspace number '2 cli'";
        "${modifier}+3" = "workspace number '3 dev'";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift+Return" = null;
        "${modifier}+${secondaryModifier}+Return" = "exec ghostty";
        "${modifier}+b" = "exec helium";
        "${modifier}+Shift+b" = null;
        "${modifier}+${secondaryModifier}+b" = null;
        "${modifier}+f" = "exec pcmanfm";
        "${modifier}+e" = "exec zeditor";
        "${modifier}+d" = "exec rofi -show drun";
        "${modifier}+w" = "exec rofi-network";
        "${modifier}+Shift+w" = null;
        "${modifier}+${secondaryModifier}+w" = null;
        "${modifier}+p" = "exec rofi-bitwarden";
        "${modifier}+Shift+q" = null;
        "${modifier}+${secondaryModifier}+q" = "kill";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "exec ${config.home.homeDirectory}/.local/bin/disable_lenovo_kb.sh toggle";
        "${modifier}+l" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Shift+h" = null;
        "${modifier}+Shift+j" = null;
        "${modifier}+Shift+k" = null;
        "${modifier}+Shift+l" = null;
        "${modifier}+Shift+Left" = null;
        "${modifier}+Shift+Down" = null;
        "${modifier}+Shift+Up" = null;
        "${modifier}+Shift+Right" = null;
        "${modifier}+${secondaryModifier}+h" = "move left";
        "${modifier}+${secondaryModifier}+j" = "move down";
        "${modifier}+${secondaryModifier}+k" = "move up";
        "${modifier}+${secondaryModifier}+l" = "move right";
        "${modifier}+${secondaryModifier}+Left" = "move left";
        "${modifier}+${secondaryModifier}+Down" = "move down";
        "${modifier}+${secondaryModifier}+Up" = "move up";
        "${modifier}+${secondaryModifier}+Right" = "move right";
        "${modifier}+Shift+1" = null;
        "${modifier}+Shift+2" = null;
        "${modifier}+Shift+3" = null;
        "${modifier}+Shift+4" = null;
        "${modifier}+Shift+5" = null;
        "${modifier}+Shift+6" = null;
        "${modifier}+Shift+7" = null;
        "${modifier}+Shift+8" = null;
        "${modifier}+Shift+9" = null;
        "${modifier}+Shift+0" = null;
        "${modifier}+${secondaryModifier}+1" = "move container to workspace number '1 web'";
        "${modifier}+${secondaryModifier}+2" = "move container to workspace number '2 cli'";
        "${modifier}+${secondaryModifier}+3" = "move container to workspace number '3 dev'";
        "${modifier}+${secondaryModifier}+4" = "move container to workspace number 4";
        "${modifier}+${secondaryModifier}+5" = "move container to workspace number 5";
        "${modifier}+${secondaryModifier}+6" = "move container to workspace number 6";
        "${modifier}+${secondaryModifier}+7" = "move container to workspace number 7";
        "${modifier}+${secondaryModifier}+8" = "move container to workspace number 8";
        "${modifier}+${secondaryModifier}+9" = "move container to workspace number 9";
        "${modifier}+${secondaryModifier}+0" = "move container to workspace number 10";
        "${modifier}+Shift+space" = null;
        "${modifier}+${secondaryModifier}+f" = "floating toggle";
        "${modifier}+Shift+minus" = null;
        "${modifier}+${secondaryModifier}+minus" = "move scratchpad";
        "${modifier}+Shift+c" = null;
        "${modifier}+${secondaryModifier}+c" = "reload";
        "${modifier}+Shift+e" = null;
        "${modifier}+${secondaryModifier}+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "XF86AudioRaiseVolume" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
      };
      workspaceAutoBackAndForth = true;
    };
    extraConfig = ''
      include /etc/sway/config.d/*
    '';
  };

}
