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
    withUWSM = true; # Better for systemd
  };

  environment.sessionVariables = {
    # Tell electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    # Required for most Wayland compositors
    nvidia.modesetting.enable = true;
  };

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

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [];
}