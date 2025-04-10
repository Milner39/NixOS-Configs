{
  username,
  ...
}:

{
  # WSL options
  wsl = {
    enable = true;

    defaultUser = username;
    startMenuLaunchers = true;

    wslConf = {

      # Windows "c" drive available under "/mnt/c"
      automount.root = "/mnt";

      interop.appendWindowsPath = false;
      network.generateHosts = false;
    }
  }
}