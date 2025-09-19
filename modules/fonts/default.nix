{
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.fonts;

  # Create args for child-modules
  childArgs = args // { inherit configRelative; };

  # Import child-modules
  nerd-fonts = (import ./nerd-fonts childArgs);
in
{
  # === Options ===
  options = {
    nerd-fonts = nerd-fonts.options;
  };
  # === Options ===


  # === Imports ===
  imports = [
    (builtins.removeAttrs nerd-fonts [ "options" ])
  ];
  # === Imports ===
}