{
  # specialArgs
  inputs,
  ...
} @ args:

{
  imports = [

  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Needs to be under `home-manager.users.<username>`
  # wayland.windowManager.hyprland = {
  #   enable = true;

  #   # Fix conflict with Home Manager
  #   # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
  #   systemd.enable = false;
  # };
}