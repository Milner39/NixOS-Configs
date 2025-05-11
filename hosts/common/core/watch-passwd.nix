{
  pkgs,
  ...
} @ args:

let
  updateScriptName = "update-hashed-password-file";
  updateScript = pkgs.writeShellScriptBin updateScriptName ''
    #!/usr/bin/env bash

    # Exit if any command fails
    set -euo pipefail


    # Get the user that had their password changed
    user="$1"

    # Get path to hashed password file
    target_file="/home/$user/.config/passwd/hashedPassword.txt"


    # Exit early if the target file does not exist
    if [[ ! -f "$target_file" ]]; then
      exit 0
    fi


    # Get the entry for the user
    shadow_entry=$(grep "^$user:" /etc/shadow)

    # Split the entry into fields by ":"
    IFS=':' read -ra fields <<< "$shadow_entry"

    # Get the hashed password
    hash="''${fields[1]}"


    # Write the new hash
    echo "$hash" > "$target_file"

    # Set secure permissions
    chown "$user:$(id -gn "$user")" "$target_file"
    chmod 600 "$target_file"
  '';


  wrapperScriptName = "passwd";
  wrapperScript = pkgs.writeShellScriptBin wrapperScriptName ''
    #!/usr/bin/env bash

    # Exit if any command fails
    set -euo pipefail


    # Run the real passwd command
    /run/wrappers/bin/passwd "$@"

    # Exit if passwd failed
    if [[ $? -ne 0 ]]; then
      exit $?
    fi


    # Get the target user (first arg or current user)
    target_user="''${1:-$(whoami)}"

    # Run the update script
    ${updateScript}/bin/${updateScriptName} "$target_user"
  '';
in
{
  # Replace `passwd` with wrapper script
  environment.systemPackages = [ wrapperScript updateScript ];
  environment.shellAliases.passwd = "${wrapperScript}/bin/${wrapperScriptName}";
  environment.pathsToLink = [ "/bin" ];
}