# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  imports = [
    ./../nixos-modules/terminal.nix
  ];

  terminal.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.auto-optimise-store = true;

  networking.hostName = "cyboogie";

  # Enable networking
  networking.networkmanager.enable = true;

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
    #
    #   #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 80; # and below it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 90; # and above it stops charging
      };
  };

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
}
