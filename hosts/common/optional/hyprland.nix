{
  pkgs,
  ...
} @ args:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    # Fix cursor flickering
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware = {
    # Fixes for Nvidia GPUs
    nvidia.modesetting.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [];
}