{
  lib,
  ...
} @ args:

let
  mkUserData = import ../../modules/nixos/user-data.nix;

  userOpts = {
    users = {
      finnm = {
        settings = {
          extraGroups = ["wheel"];
        };
        trusted = true;
      };

      mollys = {};
    };
  };
in
mkUserData { inherit lib;
  opts = userOpts;
}