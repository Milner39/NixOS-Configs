opts:

let
  # === Module ===

  module = { lib, ... }: {
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
        type = lib.types.submodule {
          options = {
            "allowUnfree" = lib.mkOption {
              description = "Whether to include packages whose licenses are marked unfree.";
              default = true;
              type = lib.types.bool;
            };

            "stable" = lib.mkOption {
              description = "The flake input for nixpkgs: to use when 'stable' pkgs are preferred.";
              default = null;  # required
              type = lib.types.raw;
            };

            "unstable" = lib.mkOption {
              description = "The flake input for nixpkgs: to use when 'unstable' pkgs are preferred.";
              type = lib.types.raw;
            };
          };
        };
      };

      "modules" = lib.mkOption {
        description = "A list of NixOS modules to include in the system evaluation.";
        default = [];
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
  };

  # === Module ===



  # === Lib ===

  lib-base = opts.nixpkgs.stable.lib;

  # === Lib ===



  # === Evaluation ===

  /*
    Evaluate the `opts` argument
    Evaluate the `module`
  */
  evaled = (lib-base.evalModules {
    modules = [ opts module ];
  }).config;


  # Create the nixos config
  nixosConfig = let

    # == Pkgs ===
    system            =  evaled.system;

    allowUnfree       =  evaled.nixpkgs.allowUnfree;
    nixpkgs           =  evaled.nixpkgs.stable;
    nixpkgs-unstable  =  evaled.nixpkgs.unstable or evaled.nixpkgs.stable;
    # Fallback to stable packages if unstable packages not provided ^

    pkgs              =  import nixpkgs {
      inherit system; config.allowUnfree = allowUnfree;
    };
    pkgs-unstable     =  import nixpkgs-unstable {
      inherit system; config.allowUnfree = allowUnfree;
    };
    # == Pkgs ===

    hostname = evaled.hostname;
    modules = evaled.modules;

    # Extend lib with lib.custom
    lib-custom = pkgs.lib.extend (self: super: {
      custom = import ../../lib { inherit (pkgs) lib; };
    });

    specialArgs = evaled.specialArgs // {
      inherit pkgs-unstable hostname;
      lib = lib-custom;
    };

  in nixpkgs.lib.nixosSystem { inherit system pkgs modules specialArgs; };

  # === Evaluation ===

in nixosConfig