{
  pkgs,
  ...
} @ args:

{
  # Import the shared Hyprland config
  imports = [(import ../common/optional/hyprland.nix args)];


  # === System Specific Tweaks

  # Using systemd so use Universal Wayland Session Manager for better support
  programs.hyprland.withUWSM = true;

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