# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  username,
  lib,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  imports = [
    ./../nixos-modules
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enables auto upgrades
  system.autoUpgrade = {
    enable = true;
    flake = "path:./../flake.nix";
    dates = "weekly";
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;

  hardware = {
    # OpenGL
    graphics.enable = true;
    # Most wayland compositors need this
    nvidia.modesetting.enable = true;
    opentabletdriver.enable = true;
  };

  networking.hostName = "han-tyumi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;

  services.auto-cpufreq.enable = true;

  # This is to fix frequent Bluetooth audio dropouts.
  boot.extraModprobeConfig = ''
    # Keep Bluetooth coexistence disabled for better BT audio stability
    options iwlwifi bt_coex_active=0

    # Enable software crypto (helps BT coexistence sometimes)
    options iwlwifi swcrypto=1

    # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
    options iwlwifi power_save=0

    # Disable Unscheduled Automatic Power Save Delivery (U-APSD) to improve BT audio stability
    options iwlwifi uapsd_disable=1

    # Disable D0i3 power state to avoid problematic power transitions
    options iwlwifi d0i3_disable=1

    # Set power scheme for performance (iwlmvm)
    options iwlmvm power_scheme=1
  '';

  # Enable system power management
  powerManagement.enable = true;

  # Enable tlp for laptop power management
  services.tlp = {
    enable = true;
    settings = {
      #   CPU_SCALING_GOVERNOR_ON_AC = "performance";
      #   CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      #
      #   CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      #   CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
      #
      #   CPU_MIN_PERF_ON_AC = 0;
      #   CPU_MAX_PERF_ON_AC = 100;
      #   CPU_MIN_PERF_ON_BAT = 0;
      #   CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 55; # and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 90; # and above it stops charging
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Allow unsupported systems
  nixpkgs.config.allowUnsupportedSystem = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
    socketActivation = true;
    # alsa = {
    #   enable = true;
    #   support32Bit = true;
    # };
  };

  # services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
  #   "monitor.bluez.properties" = {
  #     "bluez5.enable-sbc-xq" = true;
  #     "bluez5.enable-msbc" = true;
  #     "bluez5.enable-hw-volume" = true;
  #     "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
  #   };
  # };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Stell";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "video"
      "jackaudio"
      "audio"
      "cdrom"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.kdeconnect.enable = true;
  programs.steam.enable = true;

  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add missing dynamic libraries for unpackaged programs here
  # ];

  # environment.localBinInPath = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # File system management
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # VR shit
  # services.monado.enable = true;
  # programs.alvr = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix-search wget
  environment.systemPackages = with pkgs; [
    inputs.nvim.packages.${stdenv.hostPlatform.system}.nvim
    inputs.nvim.packages.${stdenv.hostPlatform.system}.tidal
    inputs.timr-tui.packages.${stdenv.hostPlatform.system}.default
    # inputs.rmpc.packages.${system}.rmpc

    bind
    bitwarden-desktop
    discord
    fractal
    firefox
    halloy
    kdePackages.kdeconnect-kde
    kdePackages.marble
    kdePackages.okular
    nwg-look
    obsidian
    openssl
    organicmaps
    prismlauncher
    qgis
    qimgv
    qjackctl
    signal-desktop
    signal-export
    stellarium
    tor
    usbutils
    gnome-disk-utility
    wine
    gnome-system-monitor
    lm_sensors
  ];

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.librewolf;
  #   policies = {
  #     DisableTelemetry = true;
  #     DisableFirefoxStudies = true;
  #     Preferences = {
  #       "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
  #       "cookiebanners.service.mode" = 2; # Block cookie banners
  #       "privacy.donottrackheader.enabled" = true;
  #       "privacy.fingerprintingProtection" = true;
  #       "privacy.resistFingerprinting" = true;
  #       "privacy.trackingprotection.emailtracking.enabled" = true;
  #       "privacy.trackingprotection.enabled" = true;
  #       "privacy.trackingprotection.fingerprinting.enabled" = true;
  #       "privacy.trackingprotection.socialtracking.enabled" = true;
  #     };
  #     ExtensionSettings = {
  #       "jid1-ZAdIEUB7XOzOJw@jetpack" = {
  #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
  #         installation_mode = "force_installed";
  #       };
  #       "uBlock0@raymondhill.net" = {
  #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
  #         installation_mode = "force_installed";
  #       };
  #     };
  #   };
  # };
  #
  # environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
