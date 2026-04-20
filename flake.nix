{
  description = "arcka's NixOS configuration for tarckan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }:
    let
      system = "x86_64-linux";
      theme = import ./theme/theme.nix;

      overlay = final: prev: {
        helium = final.callPackage ./packages/helium { };
        tpm2ssh = final.rustPlatform.buildRustPackage {
          pname = "tpm2ssh";
          version = "0.1.0";
          src = ./packages/tpm2ssh;
          cargoLock.lockFile = ./packages/tpm2ssh/Cargo.lock;
        };
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        overlays = [ overlay ];
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.tarckan = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit theme unstablePkgs;
        };
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [ overlay ];
            nixpkgs.config.allowUnfree = true;
          })
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      homeConfigurations.arcka = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit theme unstablePkgs;
          manageZedViaHomeManager = true;
        };
        modules = [ ./home/arcka.nix ];
      };
    };
}
