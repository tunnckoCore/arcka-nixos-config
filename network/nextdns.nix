{ pkgs, ... }:

{
  networking.networkmanager.dns = "systemd-resolved";
  networking.nameservers = [
    "45.90.28.100"
    "45.90.30.100"
  ];

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    fallbackDns = [
      "45.90.28.100#1ad4de.dns.nextdns.io"
      "45.90.30.100#1ad4de.dns.nextdns.io"
    ];
    dnsovertls = "true";
  };

  programs.captive-browser.enable = true;

  environment.etc."brave/policies/managed/nextdns.json".text = builtins.toJSON {
    BraveBrowserSecureDnsMode = "secure";
    BraveBrowserSecureDnsTemplate = "https://dns.nextdns.io/1ad4de";
    DnsOverHttpsMode = "secure";
    DnsOverHttpsTemplates = "https://dns.nextdns.io/1ad4de";
  };
}
