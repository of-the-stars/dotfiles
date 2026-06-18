{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    modules.system-security.enable = lib.mkEnableOption "Enable rigorous authentication";
  };

  config = lib.mkIf config.modules.system-security.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

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
