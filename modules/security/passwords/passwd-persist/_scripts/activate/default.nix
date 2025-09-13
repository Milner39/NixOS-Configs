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
      cp $src/.bash $out/bin/${activationPackageName}

      # Make only executable by root
      chmod 700 $out/bin/${activationPackageName}

      # Make packages available
      wrapProgram $out/bin/${activationPackageName} \
        --prefix PATH : ${lib.concatStringsSep ":" [
          "${pkgs.bash}/bin"
          "${pkgs.jq}/bin"
          "${pkgs.getopt}/bin"
          "${pkgs.gnused}/bin"  # sed
        ]}
    '';
  };
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Run script on activation
    system.activationScripts.${activationPackageName} = {
      text = ''
        ${activationPackage}/bin/${activationPackageName} \
          --users='${builtins.toJSON cfg.users}'
      '';
    };
  };
  # === Config ===
}

/* NOTE:
  The end goal of this module is to use SOPS-NIX and an encrypted file to 
  store passwords for users.

  I also want to make is so the hashed password files can exist somewhere in 
  the user's home directory so password setting can be handled by home manager 
  rather than the system wide config.
*/