{ theme, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = theme.font.mono;
      size = 11.0;
    };
    settings = {
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
      shell_integration = "enabled";
      background_opacity = "0.97";
      window_padding_width = 10;
      foreground = "#cad3f5";
      background = "#24273a";
      selection_foreground = "#24273a";
      selection_background = "#f4dbd6";
      color0 = "#494d64";
      color1 = "#ed8796";
      color2 = "#a6da95";
      color3 = "#eed49f";
      color4 = "#8aadf4";
      color5 = "#f5bde6";
      color6 = "#8bd5ca";
      color7 = "#b8c0e0";
      color8 = "#5b6078";
      color9 = "#ed8796";
      color10 = "#a6da95";
      color11 = "#eed49f";
      color12 = "#8aadf4";
      color13 = "#f5bde6";
      color14 = "#8bd5ca";
      color15 = "#a5adcb";
    };
  };

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
      keybind = [
        "ctrl+left=csi:1;5D"
        "ctrl+right=csi:1;5C"
        "ctrl+delete=csi:3;5~"
        "ctrl+backspace=text:\\x17"
      ];
    };
  };
}
