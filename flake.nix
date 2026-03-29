{
  description = "arcka's NixOS configuration for tarckan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      overlay = final: prev: {
        tpm2ssh = final.rustPlatform.buildRustPackage {
          pname = "tpm2ssh";
          version = "0.1.0";
          src = ./packages/tpm2ssh;
          cargoLock.lockFile = ./packages/tpm2ssh/Cargo.lock;
        };
      };
    in {
      nixosConfigurations.tarckan = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [ overlay ];
            nixpkgs.config.allowUnfree = true;
          })
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
