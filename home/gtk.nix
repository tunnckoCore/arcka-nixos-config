{ pkgs, theme, ... }:

let
  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = [ theme.accent ];
    size = "standard";
    tweaks = [ "rimless" ];
    variant = theme.variant;
  };

  cursorTheme = pkgs.catppuccin-cursors.macchiatoDark;

  iconTheme = pkgs.papirus-icon-theme.override {
    color = "blue";
  };
in {
  home.packages = [ gtkTheme iconTheme ];

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
      cursor-theme = "Catppuccin-Macchiato-Dark-Cursors";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = cursorTheme;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    size = 24;
  };
}
