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
  # === Options ===
  options = {
    video = video.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    video.config
  ];
  # === Imports ===


  # === Config ===
  config = {};
  # === Config ===
}