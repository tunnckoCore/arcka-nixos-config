{ theme, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        normal.family = theme.font.mono;
        size = 11.0;
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "none";
        opacity = 0.97;
      };
      colors = {
        primary = {
          background = "0x24273a";
          foreground = "0xcad3f5";
        };
        normal = {
          black = "0x494d64";
          red = "0xed8796";
          green = "0xa6da95";
          yellow = "0xeed49f";
          blue = "0x8aadf4";
          magenta = "0xf5bde6";
          cyan = "0x8bd5ca";
          white = "0xb8c0e0";
        };
        bright = {
          black = "0x5b6078";
          red = "0xed8796";
          green = "0xa6da95";
          yellow = "0xeed49f";
          blue = "0x8aadf4";
          magenta = "0xf5bde6";
          cyan = "0x8bd5ca";
          white = "0xa5adcb";
        };
      };
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      "font-family" = theme.font.mono;
      "gtk-titlebar" = false;
      "shell-integration" = "zsh";
      theme = "catppuccin-macchiato";
    };
  };
}
