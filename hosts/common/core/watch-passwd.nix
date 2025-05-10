{
  pkgs,
  ...
} @ args:

let
  scriptName = "update-hashed-password-file";
  scriptPath = pkgs.writeShellScriptBin scriptName ''
    #!/usr/bin/env bash

    # Exit if any command fails
    set -euo pipefail


    # Get the user that changed their password
    user="$PAM_USER"

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
    hash="${fields[1]}"


    # Write the new hash
    echo "$hash" > "$target_file"

    # Set secure permissions
    chown "$user:$(id -gn "$user")" "$target_file"
    chmod 600 "$target_file"
  '';
in
{
  security.pam.services.passwd = {
    password = [
      # Update `/etc/shadow` like usual
      { type = "required"; module = "pam_unix.so"; }

      # Run custom script
      {
        type = "optional";
        module = "pam_exec.so";
        args = "${scriptPath}/bin/${scriptName}";
      }
    ];
  };

  environment.systemPackages = [ scriptPath ];
}