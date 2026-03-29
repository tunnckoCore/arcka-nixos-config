{ pkgs, ... }:

{
  services.xserver.enable = false;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      grim
      rofi-wayland
      slurp
      swaybg
      swayidle
      swaylock
      wl-clipboard
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock = {};

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };

  environment.loginShellInit = ''
    if [ "$USER" = "arcka" ] && [ "$(tty)" = "/dev/tty1" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
      if tpm2ssh --login; then
        exec dbus-run-session sway
      fi

      printf '%s\n' 'tpm2ssh login failed; returning to tty login.'
      exit 1
    fi
  '';
}
