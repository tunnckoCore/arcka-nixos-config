{ appimageTools, fetchurl, lib, makeDesktopItem, makeWrapper, symlinkJoin }:

let
  nextDnsTemplate = "https://dns.nextdns.io/1ad4de";

  app = appimageTools.wrapType2 {
    pname = "helium";
    version = "0.10.7.1";

    src = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/0.10.7.1/helium-0.10.7.1-x86_64.AppImage";
      hash = "sha256-+vmxXcg8TkR/GAiHKnjq4b04bGtQzErfJkOb4P4nZUk=";
    };

    extraPkgs = pkgs:
      with pkgs; [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        cups
        dbus
        expat
        libdrm
        libnotify
        libpulseaudio
        libsecret
        libuuid
        mesa
        nspr
        nss
        pipewire
        wayland
      ];

    meta = {
      description = "Private, fast, and honest Chromium-based web browser";
      homepage = "https://helium.computer/";
      license = [ lib.licenses.gpl3Only lib.licenses.bsd3 ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "helium";
    };
  };

  desktopItem = makeDesktopItem {
    name = "helium";
    desktopName = "Helium";
    comment = "Private, fast, and honest web browser";
    exec = "helium --user-data-dir=/home/arcka/.config/net.imput.helium %U";
    icon = "chromium";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    startupNotify = true;
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];
  };
in
symlinkJoin {
  name = "helium-0.10.7.1";
  paths = [ app desktopItem ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/helium" \
      --add-flags "--enable-features=DnsOverHttps" \
      --add-flags "--dns-over-https-mode=secure" \
      --add-flags "--dns-over-https-templates=${nextDnsTemplate}"
  '';
  meta = app.meta;
}
