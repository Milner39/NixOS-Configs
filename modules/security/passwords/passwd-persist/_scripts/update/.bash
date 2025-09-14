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
  -l users:   \
  -- "$@"
) || {
  echo "Error: Failed to parse options." >&2
  exit 1
}
eval set -- "$OPTS"


# Set defaults for each option
users=""


# Process each option
while true; do
  case "$1" in

    # Users
    -u|--users)
      users="$2"
      shift 2
      ;;

    # End of options
    --)
      shift
      break
      ;;

    # Unexpected option
    *)
      echo "Error: Unexpected option: $1" >&2
      exit 1
      ;;

  esac
done

# === Parse Options ===



# === Validate Options ===

if [ -z "$users" ]; then
  echo "Error: -u|--users is required" >&2
  exit 1
fi
# Parse JSON into array of usernames
readarray -t users < <(jq -r '.[]' <<< "$users")

# === Validate Options ===



# === Update Hashed Password Files ===

# For each user
for user in "${users[@]}"; do
  HSH_PASSWD_FILE="${HSH_PASSWD_DIR}/${user}"
  grep "^${user}:" "/etc/shadow" | cut -d":" -f2 > "$HSH_PASSWD_FILE"
  chmod 600 "$HSH_PASSWD_FILE"
done

# === Update Hashed Password Files ===