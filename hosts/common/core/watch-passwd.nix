{
  pkgs,
  ...
} @ args:

let
  updateFileScriptName = "update-hashed-password-file";
  updateFileScript = pkgs.writeShellScriptBin updateFileScriptName ''
    # Exit if any command fails
    set -euo pipefail


    # Get the user that had their password changed (first arg)
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


  wrapperScriptName = "passwd-persist";
  wrapperScript = pkgs.writeShellScriptBin wrapperScriptName ''
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
    ${updateFileScript}/bin/${updateFileScriptName} "$target_user"
  '';
in
{
  environment.systemPackages = [ wrapperScript updateFileScript ];
  environment.shellAliases.passwd = "${wrapperScript}/bin/${wrapperScriptName}";
}