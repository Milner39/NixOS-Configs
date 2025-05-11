{
  pkgs,
  ...
} @ args:

{
  imports = [
    (import ./passwd.nix args)
  ];
}