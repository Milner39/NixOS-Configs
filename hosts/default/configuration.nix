{
  pkgs,
  hostname,
  username,
  inputs,
  ...
} @ args:

{
  imports = [
    (import ./wsl.nix args)
  ];



  # === Build ===

  # Disable building docs
  documentation.nixos.enable = false;

  # === Build ===


  # === Networking ===

  networking = {
    hostName = hostname;
  };

  # === Networking ===



  # === Users ===

  users.users.${username} = {
    # Automatically set various options like home directory etc.
    isNormalUser = true;

    # Add to groups to elevate permissions
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # === Users ===



  # === Misc ===

  time.timeZone = "Europe/London";

  # === Misc ===



  # === Nix ===

  nix = {
    settings = {
      trusted-users = [username];

      experimental-features = [ "nix-command" "flakes" ];
      accept-flake-config = true;

      auto-optimise-store = true;
    };

    # Garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.11";

  # === Nix ===



  # === Environment ===

  environment = {

    # Add globally available packages
    systemPackages = with pkgs; [
      # Version control
      git

      # Secrets
      sops
      ssh-to-age
    ];

    # Helps to ensure SSH-ing into other terminal types works
    enableAllTerminfo = true;
  };

  # === Environment ===
}