{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.passwd-persist;


  # Make alias
  cfg = configRelative;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description =

''
Whether to use custom `passwd-persist` script for updating users' 
`hashedPasswordFile`.

The following functionality should only be enabled for users with the 
`hashedPasswordFile` attribute set.


When a system is started up: the startup script should check if there is a 
non-empty file at `<user>.hashedPasswordFile`

  a) If the file exists, update the password for that user in `/etc/shadow`.
     This is already handled by NixOS.

  b) If the file does not exist, create the file and get the password from 
     `/etc/shadow`


When the `passwd-persist` command is used:

  1) The existing `passwd` command will be used to handle the authentication 
     and the updating of `/etc/shadow`.
  
  2) The script will get the new value from `/etc/shadow` and update the 
     `<user>.hashedPasswordFile`.
'';

      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {

  };
  # === Config ===
}