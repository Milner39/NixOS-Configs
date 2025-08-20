#!/usr/bin/env sh

# -e: Exit if any command fails
# -u: Treat unset variables as errors
set -eu



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
  echo "Failed to parse options." >&2
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
      echo "Unexpected option: $1" >&2
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
# Parse JSON into usernames separated by newlines
users=$(echo "$users" | jq -r '.[]')

# === Validate Options ===



# === Create Hashed Password Files ===

# Create the directory for the files
if [ ! -d "$HSH_PASSWD_DIR" ]; then
  # Delete anything with the same name so dir can be created
  rm -rf "$HSH_PASSWD_DIR"
fi
mkdir -p "$HSH_PASSWD_DIR"

# Iterate over users
echo "$users" | while IFS= read -r user; do

  # Handle the file for each user
  HSH_PASSWD_FILE="${HSH_PASSWD_DIR}/${user}"
  if [ ! -f "$HSH_PASSWD_FILE" ]; then
    # FILE DOES NOT ALREADY EXIST

    # Delete anything with the same name so file can be created
    rm -rf "$HSH_PASSWD_FILE"

    # Create the file with the user's current hash as it's content
    grep "^${user}:" "/etc/shadow" | cut -d":" -f2 > "$HSH_PASSWD_FILE"
    chmod 600 "$HSH_PASSWD_FILE"

  else
    # FILE DOES ALREADY EXIST
    true
  fi

done

# === Create Hashed Password Files ===