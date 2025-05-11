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


    echo "DEBUG 2: $USER, $(whoami), $SUDO_USER, $target_user" >&2


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


    echo "DEBUG 1: $USER, $(whoami), $SUDO_USER >&2


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

  # Add "/etc/profiles/bin" to path (higher priority than /run/wrappers/bin)
  environment.profileRelativeEnvVars.PATH = [ "/etc/profiles/bin" ];

  # Create wrapper
  environment.etc."profiles/bin/passwd" = {
    source = "${wrapperScript}/bin/${wrapperScriptName}";
    mode = "0755";
  };

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