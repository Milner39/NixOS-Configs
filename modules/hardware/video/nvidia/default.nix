{
  configRoot,
  lib,
  pkgs,
  ...
} @ args:

let
  # Get relative config position
  configRelative = args.configRelative.nvidia;
  cfg = configRelative;
in
{
  # === Options ===
  options = {
    "enable" = lib.mkOption {
      description = "Whether to enable NVIDIA Linux drivers and custom tweaks.";
      default = false;
      type = lib.types.bool;
    };


    # Options from 
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/hardware/video/nvidia.nix
    # That I want to be available here
    "modesetting"."enable" = lib.mkOption {
      description = ''
        Fixes Wayland compositors when using newer, proprietary NVIDIA drivers.
      '';
      default = (lib.versionAtLeast
        configRoot.hardware.nvidia.package.version
        "535"
      );
      type = lib.types.bool;
    };

    "powerManagement"."enable" = lib.mkOption {
      description = ''
        Enable power management, leave this off for desktops as power draw is 
        irrelevant.
      '';
      default = false;
      type = lib.types.bool;
    };

    "dynamicBoost"."enable" = lib.mkOption { default = false; };

    "videoAcceleration"."enable" = lib.mkOption { default = true; };

    "nvidiaSettings"."enable" = lib.mkOption {
      description = ''
        Add `nvidia-settings` to system packages.
        `nvidia-settings` is a tool for configuring the NVIDIA Linux graphics 
        driver.
      '';
      default = true;
      type = lib.types.bool;
    };

    "open" = lib.mkOption {
      description = ''
        Use open-source (still proprietary) NVIDIA drivers.
        Closed-source drivers currently work better with Wayland.
      '';
      default = false;
      type = lib.types.bool;
    };
  };
  # === Options ===


  # === Config ===
  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = cfg.modesetting.enable;
      powerManagement.enable = cfg.powerManagement.enable;
      dynamicBoost.enable = cfg.dynamicBoost.enable;
      videoAcceleration = cfg.videoAcceleration.enable;
      nvidiaSettings = cfg.nvidiaSettings.enable;
      open = cfg.open;
    };

    # Add video driver
    services.xserver.videoDrivers = [ "nvidia" ];
  };
  # === Config ===
}