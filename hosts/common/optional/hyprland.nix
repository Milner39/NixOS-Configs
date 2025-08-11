{
  pkgs,
  ...
} @ args:

{
  # === Hyprland ===

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    # Because NixOS uses SystemD so use UWSM for better support
    withUWSM = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [];

  # === Hyprland ===


  # === Wayland ===
  # Because Hyprland uses Wayland

  # X11 compatibility
  programs.hyprland.xwayland.enable = true;

  # Tell electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # === Wayland ===


  # === NVIDIA Fixes ===

  # Needed for Wayland
  hardware.nvidia.modesetting.enable = true;

  # Fix mouse flickering
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  # === NVIDIA Fixes ===
}