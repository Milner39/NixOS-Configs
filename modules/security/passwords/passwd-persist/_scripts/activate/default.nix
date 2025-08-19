{
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.passwd-persist;
  cfg = configRelative;


  # # Import activation script
  # activationScript = (pkgs.writeShellScriptBin
  #   "passwd-persist-activate"
  #   (builtins.readFile ./.sh)
  # );
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # # Add activation script to environment
    # environment.systemPackages = [ activationScript ];

    system.activationScripts."passwd-persist-activate" = {
      text = (builtins.readFile ./.sh);
    };
  };
  # === Config ===
}