{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    ...
  } @ inputs: let

    # Set hostname
    hostname = "WSNix";

    # Declare target architecture
    system = "x86_64-linux";

    # Import packages
    pkgs = nixpkgs.legacyPackages.${system};

    # Additional NixOS inputs
    specialArgs = { inherit inputs hostname; };
  
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;

      modules = [
        ./hosts/default/configuration.nix
      ];
    };
  };
}