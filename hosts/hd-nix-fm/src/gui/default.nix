{
  ...
} @ args:

{
  imports = [
    (import ./sddm.nix args)
    (import ./hyprland.nix args)
  ];
}