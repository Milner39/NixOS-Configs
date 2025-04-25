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

  wayland.windowManager.hyprland = {
    enable = true;

    # Fix conflict with Home Manager
    # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
    systemd.enable = false;
  };
}