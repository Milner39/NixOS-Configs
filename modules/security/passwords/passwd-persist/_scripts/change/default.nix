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
  chpasswdPackageName = "passwd-persist";
  chpasswdPackage = pkgs.stdenv.mkDerivation {
    # Info
    name = chpasswdPackageName;
    src = ./.;  # Gets set to `$src`

    # Build time deps
    nativeBuildInputs = [ pkgs.makeWrapper ];

    # Phases
    installPhase = ''
      # Move to output
      mkdir -p $out/bin
      cp $src/.bash $out/bin/${chpasswdPackageName}

      # Make only executable by root
      chmod 700 $out/bin/${chpasswdPackageName}

      # Make packages available
      wrapProgram $out/bin/${chpasswdPackageName} \
        --prefix PATH : ${lib.concatStringsSep ":" [
          "${pkgs.bash}/bin"
          "${pkgs.getent}/bin"
        ]}
    '';
  };
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Add scripts to environment
    environment.systemPackages = [ chpasswdPackage ];
  };
  # === Config ===
}