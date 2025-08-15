{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.passwords;

  # Create args for child-modules
  childArgs = { inherit configRoot configRelative lib pkgs; };

  # Import child-modules
  passwd-persist = (import ./passwd-persist childArgs);
in
{
  # === Options ===
  options = {
    passwd-persist = passwd-persist.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs passwd-persist [ "options" ])
  ];
  # === Imports ===
}