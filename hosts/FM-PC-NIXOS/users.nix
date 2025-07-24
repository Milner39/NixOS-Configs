{
  lib,
  ...
}:

lib.custom.users.mkUsersData {
  users = {
    FinnM = {
      settings = {
        description = "Finn Milner";
        extraGroups = [ "wheel" "networkmanager" ];
      };
      password = {
        useHashedFile = true;
      };
      trusted = true;
    };

    Guest = {
      settings = {
        # Public account so safe to define password
        password = "";
      };
    };
  };
}
