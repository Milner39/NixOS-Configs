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
    src = ./.;  # Gets set to `$src`

    # Build time deps
    nativeBuildInputs = [ pkgs.makeWrapper ];

    # Phases
    installPhase = ''
      # Move to output
      mkdir -p $out/bin
      cp $src/.sh $out/bin/${activationPackageName}

      # Make only executable by root
      chmod 700 $out/bin/${activationPackageName}

      # Make `jq` available
      wrapProgram $out/bin/${activationPackageName} \
        --prefix PATH : ${pkgs.jq}/bin
    '';
  };
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Run script on activation
    system.activationScripts.${activationPackageName} = {
      text = ''
        ${activationPackage}/bin/${activationPackageName} -u='${builtins.toJSON cfg.users}'
      '';
    };
  };
  # === Config ===
}