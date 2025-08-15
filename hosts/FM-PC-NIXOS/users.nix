{
  lib,
  ...
}:

lib.custom.users.mkUsersData {
  users = {
    finnm = {
      settings = {
        description = "Finn Milner";
        extraGroups = [ "wheel" "networkmanager" ];

        # ALWAYS CHANGE AFTER THE USER IS FIRST CREATED!!!
        initialPassword = "";
      };

      password = {
        # ADD WHEN passwd-persist SCRIPT FINISHED
        # useHashedFile = true;
      };

      trusted = true;
    };


    guest = {
      settings = {
        description = "Guest";

        # Public account so safe to define empty password
        password = "";
      };
    };
  };
}