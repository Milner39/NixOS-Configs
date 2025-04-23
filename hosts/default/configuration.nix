{
  lib,
  pkgs,

  # specialArgs
  inputs,
  hostname,
  username,
  ...
} @ args:

let
  # Extend args with user options
  args = args // { userData = (import ./users.nix args); };
in
{
  imports = [
    (import ../../modules/wsl/default.nix args)
    (import ./home-manager.nix args)
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

  # Gets users options from `userData.users.<username>.options`
  users.users = builtins.mapAttrs
    (name: user:
      # Get the `options` attribute, or use an empty set, and extend
      (user.options or {}) // {
        isNormalUser = true;
      }
    )
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

      # Secrets
      sops
      ssh-to-age
    ];

    # Helps to ensure SSH-ing into other terminal types works
    enableAllTerminfo = true;
  };

  # === Environment ===
}