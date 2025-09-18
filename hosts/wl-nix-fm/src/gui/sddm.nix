{
  lib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:

{
  # === Login ===

  services.displayManager = {
    # Use SDDM as display manager
    sddm = {
      enable = true;
      package = pkgs.plasma5Packages.sddm;

      wayland.enable = true;
    };
  };

  # === Login ===
}