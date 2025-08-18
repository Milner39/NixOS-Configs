lib: opts:

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

  # TODO: Turn this into a reusable filter func
  getPasswdPersistUsers = (users: (
    let
      # Create a list of usernames using a filter
      usernames = builtins.filter (
        # The filter
        (username: (
          let
            # Get the attributes of each username in the `users` set
            user = users.${username};

            # Keep the username if the it passes the filter
            keep = (user.password.passwd-persist.enable == true);
          in keep
        ))

        # The usernames
        (builtins.attrNames users)
      );

    in usernames
  ));

  # === Functions ===



  # === Module ===

  module = {...}: {
    /*
      Defines the types of the `opts` argument for easier docs and setting
      required options or default values etc.
    */
    options = {

      "users" = lib.mkOption {
        description = "A map of users by username.";
        default = null; # required
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            "settings" = lib.mkOption {
              description = "Settings for `users.users.<name>`.";
              default = {};
              type = lib.types.attrs;
            };

            "password" = lib.mkOption {
              description = "Password options.";
              default = {};
              type = lib.types.submodule {
                options = {
                  "passwd-persist"."enable" = lib.mkOption {
                    description = "Use `passwd-persist` to manage `hashedPasswordFile`.";
                    default = false;
                    type = lib.types.bool;
                  };
                };
              };
            };

            "trusted" = lib.mkOption {
              description = "If this user should be added to `nix.settings.trusted-users`.";
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


  # Create the users data set
  usersData = let
    # Make changes to `evaled.users`
    users = lib.mapAttrs (username: userCfg: lib.recursiveUpdate userCfg {

      # Add for easier access
      username = username;


      # === `users.users.<name>` Options ===
      # Add default/forced options

      settings =
        # Default options
        {

        } //

        # Custom options (from what was passed into this module)
        userCfg.settings //
        
        # Forced options
        {
          hashedPasswordFile = lib.mkIf (userCfg.password.passwd-persist.enable) (
            "/etc/passwd-persist/hashedPasswordFiles/${username}"
          );
        };

      # === `users.users.<name>` Options ===

    }) (evaled.users);

    # Get trusted users
    trusted-users = getTrustedUsers (evaled.users);

    # Get `passwd-persist` users
    passwd-persist-users = getPasswdPersistUsers (evaled.users);

  in { inherit
    users
    trusted-users
    passwd-persist-users
    ;
  };

  # === Eval ===

in usersData