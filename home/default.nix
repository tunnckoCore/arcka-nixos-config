{ theme, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit theme;
    };
    users.arcka = import ./arcka.nix;
  };
}
