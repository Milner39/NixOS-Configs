{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.video;

  # Create args for child-modules
  childArgs = { inherit configRoot configRelative lib pkgs; };

  # Import child-modules
  nvidia = (import ./nvidia childArgs);
in
{
  options = {
    nvidia = nvidia.options;
  };

  imports = [
    nvidia.config
  ];
}