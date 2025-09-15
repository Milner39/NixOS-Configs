opts:

let
  # === Lib ===

  lib = opts.nixpkgs.stable.lib;

  # === Lib ===



  # === Module ===

  module = {config, ...}: {
    /*
      Defines the types of the `opts` argument for easier docs, setting
      required options or default values, etc.
    */
    options = {
      "hostname" = lib.mkOption {
        description = ''
          The host name of the machine.
          `networking.hostName` will be set to this value.
        '';
        default = "nixos";
        type = lib.types.str;
      };

      "system" = lib.mkOption {
        description = ''
          The architecture and platform of the machine.

          See supported options:
          https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix
        '';
        default = null;  # required
        type = lib.types.str;
      };

      "nixpkgs" = lib.mkOption {
        description = "Set nixpkgs versions to use.";
        default = null;
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            "allowUnfree" = lib.mkOption {
              description = "Whether to include packages whose licenses are marked unfree.";
              default = true;
              type = lib.types.bool;
            };

            "stable" = lib.mkOption {
              description = "The nixpkgs to use when 'stable' pkgs are preferred.";
              default = null;  # required
              type = lib.types.attrsOf lib.types.anything;
            };

            "unstable" = lib.mkOption {
              description = "The nixpkgs to use when 'unstable' pkgs are preferred.";
              type = lib.types.attrsOf lib.types.anything;
            };
          };
        });
      };

      "modules" = lib.mkOption {
        description = "A list of NixOS modules to include in the system evaluation.";
        default = [ ./configuration.nix ];
        type = lib.types.listOf lib.types.raw;
      };

      "specialArgs" = lib.mkOption {
        description = ''
          An attribute set whose contents are made available as additional 
          arguments to the top-level function of every NixOS module.
        '';
        default = {};
        type = lib.types.attrsOf lib.types.raw;
      };
    };


    config = {
      # If no unstable packages were provided, use the stable packages.
      nixpkgs.unstable = lib.mkDefault config.nixpkgs.stable;
    };
  };

  # === Module ===



  # === Evaluation ===

  /*
    Evaluate the `opts` argument
    Evaluate the `module`
  */
  evaled = (lib.evalModules {
    modules = [ opts module ];
  }).config;


  # Create the nixos config
  nixosConfig = let

    # == Pkgs ===
    system            =  evaled.system;

    nixpkgs           =  evaled.nixpkgs.stable;
    nixpkgs-unstable  =  evaled.nixpkgs.unstable;
    allowUnfree       =  evaled.nixpkgs.allowUnfree;

    pkgs              =  import nixpkgs {
      inherit system; config.allowUnfree = allowUnfree;
    };
    pkgs-unstable     =  import nixpkgs-unstable {
      inherit system; config.allowUnfree = allowUnfree;
    };
    # == Pkgs ===

    hostname = evaled.hostname;
    modules = evaled.modules;

    lib-custom = lib.extend (self: super: {
      custom = import ../../lib { inherit lib; };
    });

    specialArgs = evaled.specialArgs // {
      inherit pkgs-unstable hostname;
      lib = lib-custom;
    };

  in lib.nixosSystem { inherit system pkgs modules specialArgs; };

  # === Evaluation ===

in nixosConfig