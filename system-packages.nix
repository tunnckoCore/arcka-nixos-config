{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    age
    curl
    fd
    gh
    git
    jq
    networkmanagerapplet
    nm-connection-editor
    openvpn
    pciutils
    podman
    podman-compose
    podman-tui
    ripgrep
    tpm2-tools
    tpm2ssh
    unzip
    usbutils
    wget
    wireguard-tools
    zip
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  fonts = {
    enableDefaultPackages = true;

    # Optional additions to revisit later:
    # - JetBrainsMono Nerd Font
    # - Source Han Sans / Source Han Serif
    # - Inter
    # - Geist / Geist Mono
    # - FiraCode Nerd Font
    # Example nixpkgs names to verify later:
    # - nerd-fonts.jetbrains-mono
    # - source-han-sans / source-han-serif
    # - inter
    # - geist-font
    # - geist-mono-font
    # - nerd-fonts.fira-code
    packages = with pkgs; [
      fira-code
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" "FiraCode Nerd Font" ];
      sansSerif = [ "Inter" "Noto Sans" "Source Han Sans" ];
      serif = [ "Noto Serif" "Source Han Serif" ];
    };
  };
}
