{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.hardware;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  video  =  (import ./video childArgs);
in
{
  # === Options ===
  options = {
    video  =  video.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs video [ "options" ])
  ];
  # === Imports ===
}