{ ... }:

{
  home.sessionVariables = {
    BROWSER = "helium";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "helium.desktop" ];
      "text/xml" = [ "helium.desktop" ];
      "application/xhtml+xml" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
      "x-scheme-handler/about" = [ "helium.desktop" ];
      "x-scheme-handler/unknown" = [ "helium.desktop" ];
    };
  };
}
