# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  stellae,
  syren,
  hostname,
  lib,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  discoverWrapped = pkgs.symlinkJoin {
    name = "discoverFlatpakBackend";
    paths = [
      pkgs.kdePackages.discover
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
    '';
  };
in
{
  imports = [
    ./../../nixos-modules/terminal.nix
  ];

  # kde-config.enable = true;
  terminal.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # # Enables auto upgrades
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "path:./../flake.nix";
  #   dates = "weekly";
  #   allowReboot = true;
  #   rebootWindow = {
  #     lower = "01:00";
  #     upper = "05:00";
  #   };
  # };

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 14d";
  # };

  nix.settings.auto-optimise-store = true;

  # hardware = {
  #   # # OpenGL
  #   # graphics.enable = true;
  #   # Most wayland compositors need this
  #   # nvidia.modesetting.enable = true;
  #   opentabletdriver.enable = true;
  # };

  networking.hostName = "${hostname}"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;
  #   settings = {
  #     General = {
  #       Experimental = true;
  #       FastConnectable = true;
  #     };
  #     Policy = {
  #       AutoEnable = true;
  #     };
  #   };
  # };

  # services.blueman.enable = true;

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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${stellae} = {
    isNormalUser = true;
    description = "Stellae";
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

  users.users.${syren} = {
    isNormalUser = true;
    description = "Syren";
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
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Auto-sync dotfiles for Syren
  systemd.timers."dotfiles" = {
    timerConfig = {
      OnBootSec = "5m";
      # OnUnitActiveSec = "5m";
      # Alternatively, if you prefer to specify an exact timestamp
      # like one does in cron, you can use the `OnCalendar` option
      # to specify a calendar event expression.
      # Run every Monday at 10:00 AM in the Asia/Kolkata timezone.
      #OnCalendar = "Mon *-*-* 10:00:00 Asia/Kolkata";
      # OnCalendar = "Mon *-*-* 04:00:00 America/Chicago";
      Unit = "dotfiles.service";
    };
  };

  systemd.services."dotfiles" = {
    script = ''
      set -eu
      pushd $HOME/dotfiles
      ${pkgs.git}/bin/git fetch --all
      ${pkgs.git}/bin/git rebase origin/master
      ${pkgs.git}/bin/git pull origin master --all
      popd
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${syren}";
    };
  };

  # services.displayManager.autoLogin.user = "${syren}";

  services.flatpak.enable = true;
  programs.zsh.enable = true;
  # programs.kdeconnect.enable = true;
  # programs.steam.enable = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   # Add missing dynamic libraries for unpackaged programs here
  # ];

  # environment.localBinInPath = true;

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # File system management
  # services.gvfs.enable = true;
  # services.udisks2.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
    # inputs.nvim.packages.${stdenv.hostPlatform.system}.tidal
    # inputs.timr-tui.packages.${stdenv.hostPlatform.system}.default
    # inputs.rmpc.packages.${system}.rmpc

    discoverWrapped

    aseprite
    bitwarden-desktop
    discord
    firefox
    obsidian
    openssl
    prismlauncher
    signal-desktop
    vscodium
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
