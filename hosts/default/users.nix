{
  lib,
  ...
} @ args:

let
  makeUserData = import ../../modules/nixos/user-data.nix;

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
makeUserData {
  inherit lib;
  mkUserDataArgs = { inherit users; }
}