#!/usr/bin/env sh

# -e: Exit if any command fails
# -u: Treat unset variables as errors
set -eu


# === Parse options ===

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

# === Parse options ===


# === Validate options ===

if [ -z "$users" ]; then
  echo "Error: -u|--users is required" >&2
  exit 1
fi
# Parse JSON into usernames separated by newlines
users=$(echo "$users" | jq -r '.[]')

# === Validate options ===



# Iterate over users
echo "$users" | while IFS= read -r user; do
  echo "$user"
done


# Setup Hashed Password Files




# /etc/passwd-persist/hashedPasswordFiles/<name>