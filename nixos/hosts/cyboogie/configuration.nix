# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
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
    ./../../nixos-modules
  ];

  hyprland-config.enable = false;
  media-tools.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.auto-optimise-store = true;

  networking.hostName = "cyboogie";

  # Enable networking
  networking.networkmanager.enable = false;

  # Enable system power management
  powerManagement.enable = false;

  # Enable tlp for laptop power management
  services.tlp = {
    enable = false;
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
      #
      #   #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 80; # and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 90; # and above it stops charging
    };
  };

  # Pre 25.11
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Allow unsupported systems
  nixpkgs.config.allowUnsupportedSystem = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.internet_wizard = {
    isNormalUser = true;
    description = "Stell";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "video"
      "audio"
    ];
    initialHashedPassword = "";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    inputs.nvim.packages.${system}.nvim

    element-desktop-wayland
    firefox
    obsidian
    protonvpn-gui
    qbittorrent
    signal-desktop
    stellarium
    usbutils
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
