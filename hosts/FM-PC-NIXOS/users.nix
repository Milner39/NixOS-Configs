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

        # REMOVE WHEN SECURITY FINISHED
        password = "123";
      };
      password = {
        # ADD WHEN passwd-persist SCRIPT FINISHED
        # useHashedFile = true;
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
