{
  pkgs,
  ...
} @ args:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Fix cursor flickering
    WLR_NO_HARDWARE_CURSORS = "1";

    # Tell electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    # Fixes for Nvidia GPUs
    nvidia.modesetting.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [];
}
