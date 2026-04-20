{ theme, unstablePkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit theme unstablePkgs;
      manageZedViaHomeManager = false;
    };
    users.arcka = import ./arcka.nix;
  };
}
