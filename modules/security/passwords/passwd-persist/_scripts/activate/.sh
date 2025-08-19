#!/usr/bin/env sh


# 1. Take in arguments
for arg in "$@"; do
  case $arg in
    -u=*)
      USERS="${arg#*=}"
      shift
      ;;
    *)
      echo "Unknown option: $arg"
      shift
      ;;
  esac
done


# 2. Get list of users to enable `passwd-persist` functionality for
for user in $USERS; do
  echo "$user"
done


# 3. Setup Hashed Password Files




# /etc/passwd-persist/hashedPasswordFiles/<name>