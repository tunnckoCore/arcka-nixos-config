{ pkgs, theme, ... }:

let
  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = [ theme.accent ];
    size = "standard";
    tweaks = [ "rimless" ];
    variant = theme.variant;
  };

  cursorTheme = pkgs.vanilla-dmz;

  iconTheme = pkgs.papirus-icon-theme.override {
    color = "blue";
  };
in {
  home.packages = [ gtkTheme iconTheme cursorTheme ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-${theme.variant}-Standard-Blue-Dark";
      package = gtkTheme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = iconTheme;
    };
    font = {
      name = theme.font.sans;
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-${theme.variant}-Standard-Blue-Dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "DMZ-White";
      cursor-size = 32;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    sway.enable = true;
    x11.enable = true;
    package = cursorTheme;
    name = "DMZ-White";
    size = 32;
  };
}
