{
  lib,
  ...
}:

{
  flake = import ./flake { inherit lib; };
  users = import ./users { inherit lib; };


  # Convert string to path relative to root
  fromRoot = lib.path.append ../.;  # Change this if this file moves

  # Return the first non-null value in a list
  firstNonNull = (vals: (
    builtins.head (builtins.filter
      (val: val != null)
      (vals)
    )
  ));
}