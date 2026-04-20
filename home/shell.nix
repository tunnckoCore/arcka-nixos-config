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
      nrs = "out=\"$(nix build --print-out-paths --no-link ~/nixos-config#nixosConfigurations.tarckan.config.system.build.toplevel)\" && sudo nix-env -p /nix/var/nix/profiles/system --set \"$out\" && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
      zed = "zeditor";
      nrt = "out=\"$(nix build --print-out-paths --no-link ~/nixos-config#nixosConfigurations.tarckan.config.system.build.toplevel)\" && sudo \"$out\"/bin/switch-to-configuration test";
      hms = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus home-manager switch --flake ~/nixos-config#arcka";
    };
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
      export BUN_INSTALL="$HOME/.config/bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      export PATH="$HOME/.vite-plus/bin:$PATH"
      export LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export CLAUDE_CODE_USE_OPENAI=1
      export OPENCLAUDE_DISABLE_CO_AUTHORED_BY=1
      export PI_CODING_AGENT_DIR="$HOME/.config/pi/agent"

      bindkey -e
      zmodload zsh/terminfo 2>/dev/null || true

      # Sane terminal word motions/deletions.
      [[ -n "''${terminfo[kLFT5]-}" ]] && bindkey "''${terminfo[kLFT5]}" backward-word
      [[ -n "''${terminfo[kRIT5]-}" ]] && bindkey "''${terminfo[kRIT5]}" forward-word
      [[ -n "''${terminfo[kDC5]-}" ]] && bindkey "''${terminfo[kDC5]}" kill-word

      # Common fallbacks for terminals that don't expose terminfo entries.
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[3;5~' kill-word

      # Keep normal Backspace sane. Support terminals that send Ctrl+Backspace
      # as either ^W or ^H.
      bindkey '^?' backward-delete-char
      bindkey '^W' backward-kill-word
      bindkey '^H' backward-kill-word
    '';
  };

  home.sessionVariables = {
    COLOR_SCHEME = "prefer-dark";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    GTK_THEME = "Catppuccin-Macchiato-Standard-Blue-Dark";
    XCURSOR_THEME = "DMZ-White";
    XCURSOR_SIZE = "32";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.opencode/bin"
    "$HOME/.config/bun/bin"
    "$HOME/.vite-plus/bin"
  ];

  programs.fzf.enable = true;
}
