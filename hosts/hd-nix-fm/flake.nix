{
  inputs = {
    # === Essentials ===

    nixpkgs.url           =  "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  =  "github:nixos/nixpkgs/nixos-unstable";

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
    nixpkgs-unstable,
    ...
  } @ inputs: let

    flakeTools = import ../../lib/flake {};

  in {
    nixosConfigurations = {
      /* Naming Hosts: `<usage><device>-nix-<owner>`
        <usage>   =  h (home), w (work), etc
        <device>  =  d (desktop), l (laptop), etc
        nix       =  Shows system is running NixOS
        <owner>   =  Owner's initials
      */

      # === hd-nix-fm ===
      
      "hd-nix-fm" = flakeTools.mkNixosConf {
        hostname = "hd-nix-fm";
        system = "x86_64-linux";
        nixpkgs = {
          stable = nixpkgs;
          # unstable = nixpkgs-unstable;
          # allowUnfree = true;
        };
        modules = [ ./configuration.nix ];
        specialArgs = { inherit inputs; };
      };
      
      # === hd-nix-fm ===
    };
  };
}