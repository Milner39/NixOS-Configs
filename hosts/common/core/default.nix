{
  pkgs,
  ...
} @ args:

{
  imports = [
    (import ./watch-passwd.nix args)
  ];
}