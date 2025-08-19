{
  configRelative,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  cfg = configRelative;



  # Make package
  activationPackageName = "passwd-persist-activate";
  activationPackage = pkgs.stdenv.mkDerivation {
    # Info
    name = activationPackageName;
    src = ./.sh;  # Gets set to `$src`

    # Buildtime-only deps
    nativeBuildInputs = [ pkgs.shc ];

    # Buildtime & runtime deps
    buildInputs = [ pkgs.jq ];

    # Phases
    buildPhase = ''
      shc -f $src -o ${activationPackageName}
    '';
    installPhase = ''
      mkdir $out/bin
      cp ${activationPackageName} $out/bin/
    '';
  };
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Add package to environment
    environment.systemPackages = [ activationPackage ];

    # Run script on activation
    system.activationScripts.${activationPackageName} = {
      text = ''
        ${activationPackage}/bin/${activationPackageName} -u="${builtins.toJSON cfg.users}"
      '';
    };
  };
  # === Config ===
}