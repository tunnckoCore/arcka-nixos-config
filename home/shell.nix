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
    GTK_THEME = "Catppuccin-Macchiato-Standard-Blue-Dark";
  };

  programs.fzf.enable = true;
}
