#!/usr/bin/env bash

# -e: Exit if any command fails
# -u: Treat unset variables as errors
# -o pipefail: Catch errors in pipelines
set -euo pipefail



# === Constants ===
HSH_PASSWD_DIR="/etc/passwd-persist/hashedPasswordFiles"
# === Constants ===



# === Parse Options ===

# Define the expected options
# -o: short options
# -l: long options
# Use `:` after option to indicate it takes a value, and is not a boolean
OPTS=$(getopt \
  -o u:       \
  -l user:   \
  -- "$@"
) || {
  echo "Failed to parse options." >&2
  exit 1
}
eval set -- "$OPTS"


# Set defaults for each option
user="$(whoami)"


# Process each option
while true; do
  case "$1" in

    # Users
    -u|--user)
      user="$2"
      shift 2
      ;;

    # End of options
    --)
      shift
      break
      ;;

    # Unexpected option
    *)
      echo "Unexpected option: $1" >&2
      exit 1
      ;;

  esac
done

# === Parse Options ===



# === Validate Options ===

if [ -z "$user" ]; then
  echo "Error: -u|--users is required" >&2
  exit 1
fi
# Check user exists
if ! getent passwd "$user" >/dev/null; then
  echo "Error: user '$user' does not exist" >&2
  exit 1
fi

# === Validate Options ===



# === Change Password ===

# Let `passwd` handle security and changing "/etc/shadow"
if ! passwd "$user"; then
  echo "Error: password was not changed" >&2
  exit 1
fi

# Update the hashed password file
HSH_PASSWD_FILE="${HSH_PASSWD_DIR}/${user}"
grep "^${user}:" "/etc/shadow" | cut -d":" -f2 > "$HSH_PASSWD_FILE"

# === Change Password ===