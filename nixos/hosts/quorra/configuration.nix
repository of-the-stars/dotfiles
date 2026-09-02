{
  config,
  pkgs,
  inputs,
  modulesPath,
  nixos,
  lib,
  ...
}:
let
  quorra = lib.writeShellScriptBin "quorra" ''
    niri-session
    wpaperctl set /etc/wallpaper.png
  '';
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares.nix")
    ./../../modules/nixos/terminal.nix
    ./../../modules/nixos/niri-config.nix
    ./../../modules/nixos/networking-tools.nix
    inputs.catppuccin.nixosModules.catppuccin
  ];

  modules = {
    networking-tools.enable = true;
    niri-config.enable = true;
    terminal.enable = true;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "blue";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking = {
    firewall = {
      # Open ports in the firewall.
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowedTCPPortRanges = [ ];
      allowedUDPPortRanges = [ ];

      # Or disable the firewall altogether.
      # enable = false;
    };

    hostName = baseNameOf (toString ./.); # Defines the hostname based off of the name of the parent directory

    networkmanager.enable = true; # Enable networking
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_DK.UTF-8";
      LC_IDENTIFICATION = "en_DK.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
      LC_MONETARY = "en_DK.UTF-8";
      LC_NAME = "en_DK.UTF-8";
      LC_NUMERIC = "en_DK.UTF-8";
      LC_PAPER = "en_DK.UTF-8";
      LC_TELEPHONE = "en_DK.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };

  users.users."${nixos.username}" = {
    shell = pkgs.zsh;
  };

  # Fonts
  fonts.packages = with pkgs; [ nerd-fonts.roboto-mono ];

  boot.plymouth.enable = lib.mkForce false;

  environment.etc."wallpaper.png".source = ./wallpaper.png;
  environment.systemPackages =
    with pkgs;
    [
      usbutils
    ]
    ++ [
      inputs.nvim.packages.${stdenv.hostPlatform.system}.nvim
      (pkgs.gnome-disk-utility.overrideAttrs (prev: {
        buildInputs = prev.buildInputs ++ (with pkgs; [ exfatprogs ]);
      }))
    ];
}
