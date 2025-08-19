{
  configRelative,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  cfg = configRelative;


  # Import activation script
  activationScriptName = "passwd-persist-activate";
  activationScript = (pkgs.writeShellScriptBin
    (activationScriptName)
    (builtins.readFile ./.sh)
  );
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Add activation script to environment
    environment.systemPackages = [ activationScript ];

    system.activationScripts.${activationScriptName} = {
      text = ''
        ${activationScript}/bin/${activationScriptName}
      '';
    };
  };
  # === Config ===
}