{ pkgs, ... }:

let
  rofiBitwarden = pkgs.writeShellApplication {
    name = "rofi-bitwarden";
    runtimeInputs = [ pkgs.bitwarden-cli pkgs.jq pkgs.rofi-wayland pkgs.wl-clipboard ];
    text = ''
      set -eu

      if ! bw login --check >/dev/null 2>&1; then
        printf '%s\n' 'bw is not logged in. Run bw login first.' | rofi -dmenu -p bitwarden >/dev/null
        exit 1
      fi

      session="${BW_SESSION:-}"
      if [ -z "$session" ]; then
        password="$(printf '' | rofi -dmenu -password -p 'Bitwarden unlock')"
        [ -n "$password" ] || exit 1
        session="$(BW_PASSWORD="$password" bw unlock --passwordenv BW_PASSWORD --raw)"
      fi

      selection="$(${pkgs.bitwarden-cli}/bin/bw list items --session "$session" | ${pkgs.jq}/bin/jq -r '.[] | select(.login != null) | .name' | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p 'Bitwarden')"
      [ -n "$selection" ] || exit 0

      ${pkgs.bitwarden-cli}/bin/bw list items --session "$session" \
        | ${pkgs.jq}/bin/jq -r --arg name "$selection" '.[] | select(.name == $name) | .login.password // empty' \
        | head -n1 \
        | ${pkgs.wl-clipboard}/bin/wl-copy
    '';
  };
in {
  home.packages = [ rofiBitwarden ];
}
