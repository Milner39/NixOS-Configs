{ lib, mkUserDataArgs, ... }:

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

  module = args: {
    options = {

      "users" = lib.mkOption {
        description = "A map of users by username";
        default = {};
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


    config = let
      # Apply changes to `users` option
      users = lib.mapAttrs (username: userCfg: lib.recursiveUpdate userCfg {
        # Add attributes to `<username>.settings`
        settings = userCfg.settings // {
          isNormalUser = true;
        };
      }) (args.users);

      # Get trusted users
      trusted-users = getTrustedUsers (users);
    in { inherit
      users
      trusted-users;
    };
  };

  # === Module ===



  # === Eval ===

  evalResult = lib.evalModules {
    modules = [
      { _module.args = mkUserDataArgs; }
      module
    ];
  };

  # === Eval ===

in
evalResult.config