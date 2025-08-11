{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.hardware;

  # Create args for child-modules
  childArgs = { inherit configRoot configRelative lib pkgs; };

  # Import child-modules
  video = (import ./video childArgs);
in
{
  options = {
    video = video.options;
  };

  config = {
    video = video.config;
  };
}