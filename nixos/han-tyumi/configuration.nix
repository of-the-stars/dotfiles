# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, nvim,  ... }:
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

  # Enables auto upgrades
  system.autoUpgrade = {
    enable = true;
    flake = "path:/home/internet_wizard/dotfiles/nixos/flake.nix";
    dates = "weekly";
    allowReboot = true;
    rebootWindow = { lower = "01:00"; upper = "05:00"; };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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

  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "wlp2s0";
      WIFI_IFACE = "wlp2s0";
      SSID = "han-tyumi";
      PASSPHRASE = "vomitverse";
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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

  programs.steam = {
    enable = true;
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable the Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # services.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  catppuccin.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.internet_wizard = {
    isNormalUser = true;
    description = "Stell";
    extraGroups = ["networkmanager" "wheel" "dialout" "video" "audio"];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add missing dynamic libraries for unpackaged programs here
    icu
    stdenv.cc.cc
  ];

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    WAYLAND_DISPLAY = "1";
    NIXOS_OZONE_WL =1;
  };

  environment.localBinInPath = true;

  environment.variables.PATH = "${pkgs.clang-tools}/bin:$PATH";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
    ];
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["internet_wizard"];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["internet_wizard"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # avrlibc
    inputs.nvim.packages.${system}.nvim
    pkgsUnstable.ansilove
    signal-desktop
    # wget
    alejandra
    audacity
    avrdude
    bind
    bitwarden-desktop
    bluez
    brightnessctl
    discord
    droidcam
    dunst
    dvgrab
    element-desktop
    ffmpeg
    firefox
    gimp
    grim
    halloy
    handbrake
    hyprlock
    hyprpaper
    inkscape
    kdePackages.dolphin
    # kdePackages.itinerary
    kdePackages.k3b
    kid3
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.marble
    kdePackages.okular
    kdePackages.xwaylandvideobridge
    krita
    libnotify
    lua-language-server
    luajitPackages.luarocks
    mdbook
    ncspot
    neocities
    networkmanagerapplet
    nil
    nodejs_24
    nwg-look
    obsidian
    openssl
    organicmaps
    pipewire
    pkgsCross.avr.buildPackages.binutils
    pkgsCross.avr.buildPackages.gcc
    prismlauncher
    protonvpn-gui
    qbittorrent
    qgis
    qimgv
    ravedude
    ruby
    rust-analyzer
    signal-export
    slurp
    spotify
    starship
    stellarium
    tio
    traceroute
    tree
    tree-sitter
    trunk
    usbutils
    v4l-utils
    vlc
    waybar
    wev
    wine
    wireplumber
    wofi
    yt-dlp
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
