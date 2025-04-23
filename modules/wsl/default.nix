{
  # specialArgs
  inputs,
  userData,
  ...
} @ args:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  # WSL options
  wsl = {
    enable = true;

    # Set default user to the first user defined in `userData.users`
    defaultUser = builtins.head (builtins.attrNames userData.users);

    # Disable NixOS program shortcuts in windows
    startMenuLaunchers = false;


    wslConf = {
      # Windows "c" drive available under "/mnt/c"
      automount.root = "/mnt";

      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };
  };
}