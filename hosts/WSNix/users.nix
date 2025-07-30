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
      password = {
        useHashedFile = true;
      };
      trusted = true;
    };

    Guest = {};
  };
}