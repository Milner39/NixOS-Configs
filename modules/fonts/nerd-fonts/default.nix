{
  configRoot,
  lib,
  pkgs-unstable,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.nerd-fonts;
  cfg = configRelative;

  pkg = pkgs-unstable;
in
{
  # === Options ===
  options = {
    "all" = lib.mkOption {
      description = "Whether to install all fonts from NerdFonts.";
      default = false;
      type = lib.types.bool;
    };

    "fonts" = lib.mkOption {
      description = ''
        Specific fonts to install from NerdFonts.

        This should be a function that takes `pkgs.nerd-fonts` as an argument, 
        and returns a list of packages from the package set.
      '';
      default = (_: []);
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
    };
  };
  # === Options ===


  # === Config ===
  config = {
    packages = (if cfg.all
      then builtins.filter (
        (lib.attrsets.isDerivation)
        (builtins.attrValues pkg.nerd-fonts)
      )

      else (cfg.fonts pkg.nerd-fonts)
    );
  };
  # === Config ===
}