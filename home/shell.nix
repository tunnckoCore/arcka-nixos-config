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
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#tarckan";
      zed = "zeditor";
      nrt = "sudo nixos-rebuild test --flake ~/nixos-config#tarckan";
    };
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
      export BUN_INSTALL="$HOME/.config/bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      export CLAUDE_CODE_USE_OPENAI=1
      export OPENCLAUDE_DISABLE_CO_AUTHORED_BY=1
    '';
  };

  home.sessionVariables = {
    COLOR_SCHEME = "prefer-dark";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    GTK_THEME = "Catppuccin-Macchiato-Standard-Blue-Dark";
    XCURSOR_THEME = "DMZ-White";
    XCURSOR_SIZE = "32";
  };

  programs.fzf.enable = true;
}
