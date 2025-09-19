{
  config,
  ...
} @ args:

let
  # Get relative config position
  configRelative = config.modules;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; configRoot = config; };

  # Import child-modules
  fonts     =  (import ./fonts    childArgs);
  hardware  =  (import ./hardware childArgs);
  security  =  (import ./security childArgs);
in
{
  # === Options ===
  options.modules = {
    fonts     =  fonts.options;
    hardware  =  hardware.options;
    security  =  security.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs fonts [ "options" ])
    (builtins.removeAttrs hardware [ "options" ])
    (builtins.removeAttrs security [ "options" ])
  ];
  # === Imports ===
}