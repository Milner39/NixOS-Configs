{
  lib,
  ...
}:

{
  users = import ./users { inherit lib; };


  # Convert string to path relative to root
  fromRoot = lib.path.append ../.;  # Change this if this file moves
}