{
  config,
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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Add modules
    (import ../common/core/default.nix args)
    (import ./hyprland.nix args)
  ];



  # === Build ===

  # Disable building some docs
  documentation = {
    nixos.enable = false;
    man.enable = true;
    info.enable = false;
  };

  # === Build ===


  # === Bootloader ===

  # Use SystemD bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # === Bootloader ===


  # === Kernel ===

  boot = {
    # Use latest LTS kernel
    # `pkgs.linuxPackages_latest` for latest version
    # `pkgs.linuxPackages_X_X` for specific version
    kernelPackages = pkgs.linuxPackages;
  };

  # === Kernel ===


  # === Hardware ===

  # For proprietary firmware (fix WiFi cards)
  hardware.enableRedistributableFirmware = true;

  # Nvidia drivers and fixes
  hardware.nvidia = {
    # Needed for Wayland
    modesetting.enable = true;

    # Disable GPU idle-ing
    powerManagement.enable = false;

    # Adds `nvidia-settings` to packages for fine-grain control
    nvidiaSettings = true;

    # Use proprietary Nvidia drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
  };

  # === Hardware ===


  # === Networking ===

  networking = {
    hostName = hostname;

    # Enable networking
    networkmanager = {
      enable = true;

      # WiFi options
      wifi = {
        powersave = false;
        backend = "iwd";
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # === Networking ===


  # === Security ===

  security.polkit.enable = true;

  # === Security ===


  # === Users ===

  # Gets users options from `usersData.users.<username>.settings`
  users.users = builtins.mapAttrs
    (username: userCfg: userCfg.settings)
    (args.usersData.users);

  # For password changes to persist:
  # - `usersData.users.<username>.password.useHashedFile` must be true
  # - `passwd-persist` cmd must be used to change passwords
  users.mutableUsers = false;

  # security.sudo.wheelNeedsPassword = false;

  # === Users ===


  # === Locale ===

  time.timeZone = "Europe/London";

  i18n = let
    locale = "en_GB.UTF-8";
  in
  {
    # defaultCharset = "UTF-8";
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  # Configure console keyMap
  console.keyMap = "uk";

  # === Locale ===


  # === Audio ===

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # === Audio ===


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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # === Nix ===


  # === Global Environment ===

  # Packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gh

    # Terminals
    kitty

    # Editors
    vscode

    # Browsers
    firefox
    brave

    # Other
  ];

  # Programs
  programs = {

  };

  # === Global Environment ===

}