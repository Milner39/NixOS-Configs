{
  lib,
  ...
} @ args:

let
  mkUserData = import ../../modules/nixos/user-data.nix;

  mkUserDataArgs = {
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
mkUserData { inherit lib mkUserDataArgs; }