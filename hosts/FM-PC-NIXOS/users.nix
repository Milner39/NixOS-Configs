{
  lib,
  ...
}:

lib.custom.users.mkUsersData {
  users = {


    root = {
      settings = {
        # Make sure special `root` user options are forced
        uid = 0;
        isSystemUser = true;
        home = "/root";
      };

      trusted = true;
    };


    finnm = {
      settings = {
        description = "Finn Milner";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];

        # ALWAYS CHANGE AFTER THE USER IS FIRST CREATED!!!
        initialPassword = "";
      };

      password = {
        passwd-persist.enable = true;
      };

      trusted = true;
    };


    guest = {
      settings = {
        description = "Guest";
        isNormalUser = true;

        # Public account so safe to define empty password
        password = "";
      };
    };
  };
}