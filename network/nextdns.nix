{ pkgs, ... }:

{
  networking.networkmanager.dns = "systemd-resolved";
  networking.nameservers = [
    "45.90.28.100#1ad4de.dns.nextdns.io"
    "45.90.30.100#1ad4de.dns.nextdns.io"
  ];

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [ ];
    #dns = [
    #  "45.90.28.100#1ad4de.dns.nextdns.io"
    #  "45.90.30.100#1ad4de.dns.nextdns.io"
    #];
  };
}
