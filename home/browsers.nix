{ ... }:

{
  programs.librewolf = {
    enable = true;
    policies = {
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.nextdns.io/1ad4de";
        Locked = true;
      };
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      ExtensionSettings = {
        "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-macchiato-blue/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
    settings = {
      "browser.aboutConfig.showWarning" = false;
      "browser.tabs.warnOnClose" = false;
      "identity.fxaccounts.enabled" = false;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "privacy.donottrackheader.enabled" = true;
      "ui.systemUsesDarkTheme" = 1;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };

  home.file.".config/brave-flags.conf".text = ''
    --force-dark-mode
    --enable-features=WebUIDarkMode,CSSColorSchemeUARendering
  '';
}
