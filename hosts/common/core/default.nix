{
  pkgs,
  ...
} @ args:

{
  imports = [
    (import ./passwd-persist.nix args)
  ];
}