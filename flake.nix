{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    ...
  } @ inputs: let

    # Set hostname and username
    hostname = "wsnix";
    username = "finnm";


    # Declare target architecture
    system = "x86_64-linux";

    # Import packages
    pkgs = import nixpkgs { inherit system; };

    # Additional NixOS inputs
    specialArgs = { inherit inputs hostname username; };
  
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;

      modules = [
        ./hosts/default/configuration.nix
      ];
    };
  };
}