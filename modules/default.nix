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
in
{
  options.modules = {
    hardware = hardware.options;
  };

  imports = [
    hardware.config
  ];

  config = {};
}