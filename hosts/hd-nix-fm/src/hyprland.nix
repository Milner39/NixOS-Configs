{
  lib,
  pkgs,
  pkgs-unstable,
  ...
} @ args:

{
  imports = [
    # Import the shared Hyprland config
    (import (lib.custom.fromRoot "hosts/common/optional/hyprland.nix") args)
  ];


  # === Hyprland Tweaks ===

  # === Hyprland Tweaks ===


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


  # === System-Wide Customisation ===

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

  # === System-Wide Customisation ===
}