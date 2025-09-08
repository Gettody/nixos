{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, ... }:
    let 
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.default
          ];
        };

        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/iso/configuration.nix
            nixos-generators.nixosModules.all-formats
          ];
        };
      };

      homeConfigurations.leo = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./users/leo/default.nix ];
      };

      packages.${system}.iso = self.nixosConfigurations.iso.config.formats.iso;
  };
}
