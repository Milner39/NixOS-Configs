{
  config,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = config.modules;

  # Create args for child-modules
  childArgs = {
    configRoot = config;
    inherit configRelative lib pkgs;
  };

  # Import child-modules
  hardware = (import ./hardware childArgs);
  security = (import ./security childArgs);
in
{
  # === Options ===
  options.modules = {
    hardware = hardware.options;
    security = security.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs hardware [ "options" ])
    (builtins.removeAttrs security [ "options" ])
  ];
  # === Imports ===
}