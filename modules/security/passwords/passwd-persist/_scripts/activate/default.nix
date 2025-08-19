{
  configRelative,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  cfg = configRelative;


  # Import script
  activationScriptName = "passwd-persist-activate";
  activationScript = (pkgs.writeShellScriptBin
    (activationScriptName)
    (builtins.readFile ./.sh)
  );
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Add script to environment
    environment.systemPackages = [ activationScript ];

    # Run script on activation
    system.activationScripts.${activationScriptName} = {
      text = ''
        ${activationScript}/bin/${activationScriptName}
      '';
    };
  };
  # === Config ===
}