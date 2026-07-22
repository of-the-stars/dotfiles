{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    modules.system-security.enable = lib.mkEnableOption "Enable rigorous authentication";
  };

  config = lib.mkIf config.modules.system-security.enable {
    programs.yubikey-manager.enable = true;

    services.gnome.gnome-keyring.enable = true;
    services.passSecretService.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services = {
      pcscd.enable = true; # Smartcard service
      udev.packages = [ pkgs.yubikey-personalization ];
    };

    security.pam = {
      services = {
        login = {
          u2fAuth = true;
          enableGnomeKeyring = true;
        };
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };

      u2f = {
        enable = true;
        settings = {
          interactive = false; # Tells user to insert their key
          cue = false; # Tells user that they have to press the button
          origin = "pam://yubi";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      seahorse
      yubioath-flutter
    ];
  };
}
