{
  pkgs,

  # specialArgs
  inputs,
  hostname,
  ...
} @ baseArgs:

let
  # Extend args with user options
  args = baseArgs // { userData = (import ./users.nix baseArgs); };
in
{
  imports = [
    (import ../../modules/wsl args)
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

  # Gets users options from `userData.users.<username>.settings`
  users.users = builtins.mapAttrs
    (username: userCfg: userCfg.settings)
    (args.userData.users);

  security.sudo.wheelNeedsPassword = false;

  # === Users ===



  # === Misc ===

  time.timeZone = "Europe/London";

  # === Misc ===



  # === Nix ===

  nix = {
    settings = {
      trusted-users = args.userData.trusted-users;

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

      # User home environments
      home-manager

      # Secrets
      sops
      ssh-to-age
    ];

    # Helps to ensure SSH-ing into other terminal types works
    enableAllTerminfo = true;
  };

  # === Environment ===
}