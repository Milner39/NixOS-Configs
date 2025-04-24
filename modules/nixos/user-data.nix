{ lib, opts }:

let
  # === Functions ===

  getTrustedUsers = (users:
    # Take in a map of users by username

    # Filter a list of username strings
    builtins.filter (username:
      # Get the attributes of each username
      let user = users.${username}; in
      # If the user is trusted, keep it in the list
      user.trusted
    )
    # Pass the list of usernames to the filter function
    (builtins.attrNames users)
  );

  # === Functions ===



  # === Module ===

  module = {...}: {
    /* 
      Defines the types of the `opts` argument for easier docs and setting 
      required options or default values etc.
    */
    options = {

      "users" = lib.mkOption {
        description = "A map of users by username";
        required = true;
        type = lib.types.attrsOf (lib.types.submodule {

          options = {
            "settings" = lib.mkOption {
              description = "Settings for `users.users.<username>`";
              default = {};
              type = lib.types.attrs;
            };

            "trusted" = lib.mkOption {
              description = "If this user should be added to `nix.settings.trusted-users`";
              default = false;
              type = lib.types.bool;
            };
          };

        });
      };

    };
  };

  # === Module ===



  # === Eval ===

  /*
    Evaluate the `opts` argument and retrieve the results after option values 
    have been checked and updated with defaults.
  */
  evaled = (lib.evalModules {
    modules = [ opts module ];
  }).config;


  # Create the user data set
  userData = let
    # Make changes to `evaled.users`
    users = lib.mapAttrs (username: userCfg: lib.recursiveUpdate userCfg {
      # Add default attributes to `<username>.settings`
      settings = userCfg.settings // {
        isNormalUser = true;
      };
    }) (evaled.users);

    # Get trusted users
    trusted-users = getTrustedUsers (evaled.users);
  in { inherit
    users
    trusted-users;
  };

  # === Eval ===

in
userData