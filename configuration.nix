{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./mounts.nix
    ./system-packages.nix
    ./users/arcka.nix
    ./desktop/tty1-sway.nix
    ./network/nextdns.nix
    ./home/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "arcka" ];
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
