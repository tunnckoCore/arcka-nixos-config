{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system-packages.nix
    ./users/arcka.nix
    ./desktop/tty1-sway.nix
    ./network/nextdns.nix
    ./home/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tarckan";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Sofia";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.fstrim.enable = true;
  services.printing.enable = false;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    arcka ALL=(root) NOPASSWD: /run/current-system/sw/bin/tee /sys/devices/platform/i8042/*/inhibited
  '';

  security.tpm2 = {
    enable = true;
    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "device";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.ssh.startAgent = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      mesa
      nspr
      nss
      pango
      stdenv.cc.cc.lib
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "arcka" ];
    min-free = 1024 * 1024 * 1024;
  };

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "25.05";
}
