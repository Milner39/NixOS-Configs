{
  lib,
  ...
} @ args:

let
  mkUserData = import ../../modules/nixos/user-data.nix;

  users = {
    finnm = {
      options = {
        extraGroups = ["wheel"];
      };
      trusted = true;
    };

    mollys = {};
  };
in
mkUserData {
  inherit lib;
  mkUserDataArgs = { inherit users; }
}