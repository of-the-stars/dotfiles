{
  config,
  pkgs,
  lib,
  stellae,
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

    # services.gnome.gnome-keyring.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services = {
      pcscd.enable = true; # Smartcard service
      udev.packages = [ pkgs.yubikey-personalization ];
    };

    security.pam.services = {
      login.u2fAuth = true;
      sudo = {
        u2fAuth = true;
        sshAgentAuth = true;
      };
    };

    security.pam.u2f = {
      enable = true;
      settings = {
        interactive = false; # Tells user to insert their key
        cue = false; # Tells user that they have to press the button
        origin = "pam://yubi";
        authfile = pkgs.writeText "u2f-mappings" (
          lib.concatStrings [
            "${stellae}"
            ":3yeemgb2knfpfrl/DGz7elMGvG1BPnqoBG9ljfehDc/gy5uOPEuVMT2NxTwBSY/J8YN1c4QioxnPicy9/uY35w==,W0FTw53ADEn7KNtPvdDEQ5D44ZQcF65NT+Xomht5JmbJpK+3aPkvZsTx846hVcb6TJP1PGUCD5xyk6llAKX6uA==,es256,+presence"
          ]
        );
      };
    };

    environment.systemPackages = with pkgs; [
      seahorse
      yubioath-flutter
    ];
  };
}
