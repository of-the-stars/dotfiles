# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, nvim, unstable, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    <catppuccin/modules/nixos>
  ];

  # gtk = {
  #     enable = true;
  #     catppuccin = {
  #       enable = true;
  #       flavor = "mocha";
  #       accent = "pink";
  #       size = "standard";
  #       tweaks = [ "normal" ];
  #     };
  # };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enables catppuccin color scheme
  catppuccin.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enables auto upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  environment.localBinInPath = true;

  networking.hostName = "han-tyumi"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.create_ap = {
    enable = true;
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

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Allow unsupported systems
  # nixpkgs.config.allowUnsupportedSystem = true;

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable the Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.internet_wizard.uid}"; # User-id must match the user running MPD. MPD will look inside this directory for the PipeWire socket.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.internet_wizard = {
    isNormalUser = true;
    description = "Stell";
    extraGroups = ["networkmanager" "wheel" "dialout" "video" "audio"];
    packages = with pkgs; [
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  
  # Enable Home Manager
  home-manager.users.internet_wizard = { pkgs, ... }: {
    home.packages = with pkgs; [ ];
    # programs.bash.enable = true;
  
    # This value determines the Home Manager release that your configuration is 
    # compatible with. This helps avoid breakage when a new Home Manager release 
    # introduces backwards incompatible changes. 
    #
    # You should not change this value, even if you update Home Manager. If you do 
    # want to update the value, then make sure to first check the Home Manager 
    # release notes. 
    home.stateVersion = "25.05"; # Please read the comment before changing. 
  
    # Enable the music player damon
    services.mpd = {
      enable = true;
      musicDirectory = "/home/internet_wizard/Music";
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "my pipewire"
            mixer_device "default"
            mixer_control "PCM"
          }
        '';
  
      network.port = 6600;
    
      # Optional:
      network.listenAddress = "any"; # if you want to allow non-localhost connections
      # network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
      # user = "internet_wizard";
    };
  
  }; 

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["internet_wizard"];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add missing dynamic libraries for unpackaged programs here
    icu
    stdenv.cc.cc
  ];

  # Install neovim and set as default editor
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["internet_wizard"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  environment.variables = {
    SUDO_EDITOR = "nvim";
    EDITOR = "nvim";
    VISUAL = "nvim";
    SYSTEMD_EDITOR = "nvim";
    TERM = "kitty";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Configure nixpkgs
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          config = config.nixpkgs.config;
        };
      };
    };
  };

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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.variables.PATH = "${pkgs.clang-tools}/bin:$PATH";

  programs.starship = {
    enable = true;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    WAYLAND_DISPLAY = "1";
    NIXOS_OZONE_WL =1;
  };

  hardware = {
    # OpenGL
    graphics.enable = true;
    # Most wayland compositors need this
    nvidia.modesetting.enable = true;
    opentabletdriver.enable = true;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # builtins.trace (builtins.attrNames inputs) "Debug message";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # avrlibc
    # nvim.defaultPackage.${pkgs.system}
    # unstable.ansilove
    # unstable.signal-desktop
    # wget
    alejandra
    audacity
    avrdude
    bat
    bind
    bitwarden-desktop
    bitwarden-cli
    bluez
    brightnessctl
    cargo
    cargo-generate
    cargo-info
    cargo-make
    clang
    clang-tools
    direnv
    discord
    docker
    droidcam
    dunst
    dvgrab
    element-desktop
    fastfetch
    ffmpeg
    firefox
    fzf
    gcc
    gimp
    git
    gnumake
    grim
    halloy
    handbrake
    htop-vim
    hyprlock
    hyprpaper
    inkscape
    kdePackages.dolphin
    # kdePackages.itinerary
    kdePackages.k3b
    nix-search-cli
    openconnect
    kid3
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.marble
    kdePackages.okular
    kdePackages.xwaylandvideobridge
    kitty
    krita
    lazygit
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
    python3
    qbittorrent
    qgis
    qimgv
    ravedude
    rename
    ripgrep
    rmpc
    ruby
    rust-analyzer
    rustup
    screen
    signal-export
    slurp
    spotify
    starship
    steam
    stellarium
    stow
    tiny
    tio
    traceroute
    tree
    tree-sitter
    trunk
    unzip
    usbutils
    v4l-utils
    vim
    vlc
    waybar
    wev
    whois
    wine
    wireplumber
    wl-clipboard
    wofi
    yazi
    yt-dlp
    zoxide
  ];
}
