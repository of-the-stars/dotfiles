{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
in
{
  imports = [
    ./home-modules
  ];

  # Adds each spell in my spellbook to PATH as a derivation with a binary :]
  # Gosh do I love the fact that Nix is a whole functional language too
  # I love functional programming
  home.packages = builtins.attrValues (
    let
      spellbookPath = ./../spellbook;
    in
    pkgs.lib.mapAttrs'
      (
        # Evaluates to a list of name and value pairs that then get passed to mapAttrs'
        # to then get turned into an attribute set
        name: value:
        # Maps the name of the file to a camelCase version without the file suffix
        pkgs.lib.nameValuePair (pkgs.lib.toCamelCase (pkgs.lib.removeSuffix ".sh" name))
          # Returns a derivation with a binary that's the name of the script without the extension
          # and the content is the script itself
          (
            pkgs.writeShellScriptBin (pkgs.lib.removeSuffix ".sh" name) (
              builtins.readFile (spellbookPath + ("/" + name))
            )
          )
      )
      # Returns an attribute set with only the `.sh` files as the names of the values
      (pkgs.lib.filterAttrs (name: type: pkgs.lib.hasSuffix ".sh" name) (builtins.readDir spellbookPath))
  );

  # Iterates through the ".config" directory in the root of the repo and lets home manager make symlinks to them
  xdg.configFile =
    let
      configPath = ./../.config;
    in
    pkgs.lib.mapAttrs
      (
        # For each file name, it sets its value to the attribute set containing its source as being the
        # configPath + the file's name
        name: value: { source = configPath + ("/" + name); })
      (
        # Returns an attribute set with all non-backup files as the names and what kind of file they are as
        # the value
        pkgs.lib.filterAttrs (name: type: !(pkgs.lib.hasSuffix ".bak" name)) (builtins.readDir configPath)
      );

  home.file = {
    ".gitconfig".source = ./../.gitconfig;
    ".secrets".source = ./../.secrets;
    # ".bash_aliases".source = ./../.bash_aliases;
    # ".bashrc".source = ./../.bashrc;
    # ".stow-global-ignore".source = ./../.stow-global-ignore;
    # ".zshrc".source = ./../.zshrc;
    # "spellbook".source = ./../spellbook;
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
