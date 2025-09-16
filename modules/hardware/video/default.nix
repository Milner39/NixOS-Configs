{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.video;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  nvidia = (import ./nvidia childArgs);
in
{
  # === Options ===
  options = {
    nvidia = nvidia.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs nvidia [ "options" ])
  ];
  # === Imports ===
}