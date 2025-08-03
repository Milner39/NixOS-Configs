{
  lib,
  pkgs,
  ...
} @ args:

{
  imports = [
    # Import the shared Hyprland config
    (import (lib.custom.fromRoot "hosts/common/optional/hyprland.nix") args)
  ];


  # === System Specific Tweaks

  # Because this system uses SystemD so use UWSM for better support
  programs.hyprland.withUWSM = true;

  # Because this system uses Wayland
  programs.xwayland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Tell electron apps to use Wayland

  # === System Specific Tweaks


  # === Login ===

  services.displayManager = {
    # Use SDDM as display manager
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # === Login ===


  # === Global Customisation ===

  environment.systemPackages = with pkgs; [
    # Status bar
    waybar

    # Wallpaper
    hyprpaper

    # App launcher
    rofi-wayland

    # Notifications
    mako
    libnotify
  ];

  # === Global Customisation ===
}