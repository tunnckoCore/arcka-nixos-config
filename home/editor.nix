{ theme, ... }:

{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      load_direnv = "shell_hook";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        shell = {
          program = "zsh";
        };
      };
      theme = {
        mode = "dark";
        dark = "Catppuccin Macchiato";
        light = "Catppuccin Latte";
      };
      buffer_font_family = theme.font.mono;
      ui_font_family = theme.font.sans;
    };
  };
}
