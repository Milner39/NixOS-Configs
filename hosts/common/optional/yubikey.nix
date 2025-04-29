{
  pkgs,
  ...
} @ args:

{
  # Smartcard service
  services.pcscd.enable = true;

  # More yubikey customisation options
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # yubikey login / sudo
  security.pam = {
    # Let users use yubikey to ssh
    sshAgentAuth.enable = true;

    # 2FA
    u2f = {
      enable = true;

      settings = {
        # Tells user they need to press the yubikey button
        cue = true;
      };

      # Set services that can use 2FA
      services = {
        login = {
          u2fAuth = true;
        };
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };
  };
}