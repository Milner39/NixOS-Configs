{
  inputs = {
    # === Essentials ===

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # === Essentials ===


    # === Utilities ===

    # Secret management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Utilities ===
  };



  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let

    # Extend lib with lib.custom
    lib = nixpkgs.lib.extend (self: super: {
      custom = import ./lib { inherit (nixpkgs) lib; };
    });

    baseSpecialArgs = { inherit
      inputs
      lib;
    };

  in {
    nixosConfigurations = {
      /* Naming Hosts: `<usage><device>-nix-<owner>`
        <usage>   =  h (home), w (work), etc
        <device>  =  d (desktop), l (laptop), etc
        nix       =  Shows system is running NixOS
        <owner>   =  Owner's initials
      */


      # === hd-nix-fm ===
      
      "hd-nix-fm" = let
        hostname = "hd-nix-fm";
        
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
	      specialArgs = baseSpecialArgs // { inherit
          hostname;
        };

      in nixpkgs.lib.nixosSystem {
        inherit system pkgs specialArgs;

        modules = [
          ./hosts/hd-nix-fm/configuration.nix
        ];
      };
      
      # === hd-nix-fm ===
    };
  };
}