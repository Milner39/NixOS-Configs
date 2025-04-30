{
  pkgs,

  # specialArgs
  inputs,
  hostname,
  ...
} @ baseArgs:

let
  # Extend args with users data
  args = baseArgs // { usersData = (import ./users.nix baseArgs); };
in
{
  imports = [
    (import ../common/optional/wsl.nix args)
    (import ../common/optional/yubikey.nix args)
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

  # Gets users options from `usersData.users.<username>.settings`
  users.users = builtins.mapAttrs
    (username: userCfg: userCfg.settings)
    (args.usersData.users);

  security.sudo.wheelNeedsPassword = false;

  # === Users ===



  # === Misc ===

  time.timeZone = "Europe/London";

  # === Misc ===



  # === Nix ===

  nix = {
    settings = {
      trusted-users = args.usersData.trusted-users;

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