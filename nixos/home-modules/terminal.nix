{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    terminal.enable =
      lib.mkEnableOption "My terminal preferences";
  };

  config = lib.mkIf config.terminal.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
      };

      oh-my-zsh = {
        enable = true;
        theme = "minimal";
      };

      initContent = ''
        bindkey -v

        # panasonic camcorder helper functions

        panasonic-grab() {
            # pulls video and splits recordings into .avi files from my Panasonic camcorder
            dvgrab -V -input $1 --timestamp --size 0 --showstatus --autosplit --format dv2 dv-
            panasonic-rename
        }

        panasonic-rename() {
            # renames the videos grabbed by the panasonic-grab() function into ISO compliant filenames with the date and time
            rename -v 's/dv-19([0-9]{2}).([0-9]{2}).([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})/20$1$2$3T$4$5$6/' *
        }

        # unzip-all

        unzip-all() {
            for a in *.zip; do unzip "$a" -d "''${a%.zip}"; done
        }
      '';
    };

    /*
       home.shell = {
      enableZshIntegration = true;
    };
    */

    home.shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";

      # Add an "alert" alias for long running commands.  Use like so:
      #   sleep 10; alert
      alert = ''
        notify-send --urgency=high -i "$([ $? = 0 ] && echo terminal || echo error)"
      '';

      # This was part of the above command, idk how to add it in again
      # TODO: Fix this and incorporate it back into the previous command

      # "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"

      icat = "kitten icat";
      cd = "z";
      c = "clear";
      ls = "eza";
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
      colors = "auto";
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
    };
  };
}
