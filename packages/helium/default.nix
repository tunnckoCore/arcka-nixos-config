{ appimageTools, fetchurl, lib, makeDesktopItem, symlinkJoin }:

let
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
    exec = "helium --user-data-dir=/home/charlike/.config/net.imput.helium %U";
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
  meta = app.meta;
}
