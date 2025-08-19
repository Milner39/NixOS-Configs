#!/usr/bin/env sh


# 1. Take in arguments
for arg in "$@"; do
  case $arg in
    -u=*)
      RAW_JSON="${arg#*=}"  # Remove `-u=`
      USERS=$(echo "$RAW_JSON" | jq -r '.[]')  # Parse JSON into usernames separated by newlines
      shift
      ;;
    *)
      echo "Unknown option: $arg"
      shift
      ;;
  esac
done


# Iterate over users
echo "$USERS" | while IFS= read -r USER; do
  echo "$USER"
done


# 3. Setup Hashed Password Files




# /etc/passwd-persist/hashedPasswordFiles/<name>