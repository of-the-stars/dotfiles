{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  # Creates executable scripts under the `spellbook` attrset from my ./../spellbook/
  spellbook = {
    knock-knock = pkgs.writeShellApplication {
      name = "knock-knock";
      text = builtins.readFile ./../spellbook/knock-knock.sh;
      runtimeInputs = with pkgs; [
        bat
        busybox
        mktemp
        nmap
        ripgrep
      ];
    };

    open-file = pkgs.writeShellApplication {
      name = "open-file";
      text = builtins.readFile ./../spellbook/open-file.sh;
      runtimeInputs = with pkgs; [
        eza
        fd
        handlr
        rofi
      ];
    };

    rebuild = pkgs.writeShellApplication {
      name = "rebuild";
      text = builtins.readFile ./../spellbook/rebuild.sh;
      runtimeInputs = with pkgs; [
        coreutils
        fzf
        git
        jq
        nix
        pipewire
        ripgrep
      ];
    };

    ux-up = pkgs.writeShellScriptBin "ux-up" (builtins.readFile ./../spellbook/ux-up.sh);

    whos-there = pkgs.writeShellApplication {
      name = "whos-there";
      text = builtins.readFile ./../spellbook/whos-there.sh;
      runtimeInputs = with pkgs; [ ];
    };
  };

  pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in
{
  imports = [
    ./home-modules
  ];

  # Adds each spell to PATH for me :]
  home.packages = (map (spell: spellbook.${spell}) (builtins.attrNames spellbook));

  # Iterates through the ".config" directory in the root of the repo and lets home manager make symlinks to them
  xdg.configFile =
    let
      configPath = ./../.config;
    in
    pkgs.lib.mapAttrs (name: value: { source = configPath + ("/" + name); }) (
      pkgs.lib.filterAttrs (name: type: !(pkgs.lib.hasSuffix ".bak" name)) (builtins.readDir configPath)
    );

  home.file = {
    ".secrets".source = ./../.secrets;
    ".gitconfig".source = ./../.gitconfig;

    ".bashrc".source = ./../.bashrc;
    # ".zshrc".source = ./../.zshrc;
    ".bash_aliases".source = ./../.bash_aliases;

    ".stow-global-ignore".source = ./../.stow-global-ignore;
    "spellbook".source = ./../spellbook;
  };

  services.tomat = {
    enable = true;
    package = pkgsUnstable.tomat;
    settings = {
      timer = {
        work = 25;
        break = 5;
        long_break = 15;
        sessions = 4;
        auto_advance = "none"; # Auto-advance mode: "none", "all", "to-break", "to-work"
      };
      sound = {
        mode = "none";
        volume = 0.5; # Volume level (0.0 to 1.0)
        # Optional: Custom sound files (will override embedded sounds)
        # work_to_break = "/path/to/custom/work-to-break.wav";
        # break_to_work = "/path/to/custom/break-to-work.wav";
        # work_to_long_break = "/path/to/custom/work-to-long-break.wav";
      };
      notification = {
        icon = "theme"; # Icon mode: "auto" (embedded), "theme" (system), or "/path/to/icon.png"
        urgency = "low";
        timeout = 10000; # Notification timeout in milliseconds
        work_message = "Break time! Step away from the screen.";
        break_message = "Back to work! Let's get things done.";
        long_break_message = "Long break! You've earned it.";
      };
      display = {
        text_format = "{state} {phase}: {time}";
      };
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
}
