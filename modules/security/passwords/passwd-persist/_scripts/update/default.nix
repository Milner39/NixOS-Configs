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
  updateHashPackageName = "passwd-persist-update";
  updateHashPackage = pkgs.stdenv.mkDerivation {
    # Info
    name = updateHashPackageName;
    src = ./.;  # Gets set to `$src`

    # Build time deps
    nativeBuildInputs = [ pkgs.makeWrapper ];

    # Phases
    installPhase = ''
      # Move to output
      mkdir -p $out/bin
      cp $src/.bash $out/bin/${updateHashPackageName}

      # Make only executable by root
      chmod 700 $out/bin/${updateHashPackageName}

      # Make packages available
      wrapProgram $out/bin/${updateHashPackageName} \
        --prefix PATH : ${lib.concatStringsSep ":" [
          "${pkgs.bash}/bin"
          "${pkgs.jq}/bin"
          "${pkgs.getopt}/bin"
        ]}
    '';
  };
in
{
  # === Config ===
  config = lib.mkIf cfg.enable {
    # Run script when `/etc/shadow` is changed
    systemd = {
      services."${updateHashPackageName}".serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${updateHashPackage}/bin/${updateHashPackageName} \
            --users='${builtins.toJSON cfg.users}'
        '';
      };

      paths."${updateHashPackageName}" = {
        pathConfig.PathChanged = "/etc/shadow";
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
  # === Config ===
}