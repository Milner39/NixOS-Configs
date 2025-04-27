{
  lib,
  ...
} @ args:

let
  mkUserData = import ../../modules/nixos/user-data.nix;

  userOpts = {
    users = {
      FinnM = {
        settings = {
          extraGroups = ["wheel"];
        };
        trusted = true;
      };
    };
  };
in
mkUserData { inherit lib;
  opts = userOpts;
}