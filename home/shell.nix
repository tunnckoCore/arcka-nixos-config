{ config, ... }:

{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    history = {
      size = 100000;
      path = "${config.xdg.stateHome}/zsh/history";
    };
    shellAliases = {
      lsal = "ls --color=always -v --group-directories-first -F -l";
      gs = "git status -sb";
    };
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  home.sessionVariables = {
    COLOR_SCHEME = "prefer-dark";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    GTK_THEME = "Catppuccin-Macchiato-Standard-Blue-Dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    XCURSOR_THEME = "Catppuccin-Macchiato-Dark-Cursors";
    XCURSOR_SIZE = "24";
  };

  programs.fzf.enable = true;
}
