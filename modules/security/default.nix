{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.security;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  passwords = (import ./passwords childArgs);
in
{
  # === Options ===
  options = {
    passwords = passwords.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs passwords [ "options" ])
  ];
  # === Imports ===
}