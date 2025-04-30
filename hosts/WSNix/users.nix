{
  lib,
  ...
}:

lib.custom.users.mkUsersData {
  users = {
    FinnM = {
      settings = {
        extraGroups = ["wheel"];
      };
      trusted = true;
    };
  };
}