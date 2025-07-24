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
    target_user="$1"

    # Check if invoked by non-sudoer or non-target user
    if [ -n "$SUDO_USER" ] && [ "$target_user" != "$SUDO_USER" ]; then
      echo "${updateFileScriptName}: You may not update the hashed password file for $target_user." >&2
      exit 1
    fi
    # Prevents non-sudoers from triggering updates for other users


    # Get path to hashed password file
    target_file="/home/$target_user/.config/passwd/hashedPassword.txt"

    # Exit early if the target file does not exist
    if [[ ! -f "$target_file" ]]; then
      exit 0
    fi


    # Get the entry for the target user
    shadow_entry=$(grep "^$target_user:" /etc/shadow)

    # Split the entry into fields by ":"
    IFS=':' read -ra fields <<< "$shadow_entry"

    # Get the hashed password
    hash="''${fields[1]}"


    # Write the new hash
    echo "$hash" > "$target_file"

    # Set secure permissions
    chown "$target_user:$(id -gn "$target_user")" "$target_file"
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
    # This is extremely important because passwd does all the authentication


    # Get the target user (first arg or current user)
    target_user="''${1:-$(whoami)}"

    # Run the update script
    sudo ${updateFileScript}/bin/${updateFileScriptName} "$target_user"
  '';
in
{
  # Add scripts to environment
  environment.systemPackages = [ wrapperScript updateFileScript ];

  # Alias passwd to wrapper script
  environment.shellAliases.passwd = "${wrapperScript}/bin/${wrapperScriptName}";

  # Let update-hashed-password-file script be run as root by anyone
  # NOTE: Security measures have been made within the script
  security.sudo.extraRules = [{
    users = [ "ALL" ];
    commands = [{
      command = "${updateFileScript}/bin/${updateFileScriptName}";
      options = [ "NOPASSWD" ];
    }];
  }];
}


# There is currently a problem when trying to update passwords as with sudo for
# other users
