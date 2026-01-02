{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
    terminal.enable = lib.mkEnableOption "My terminal preferences";
  };

  config = lib.mkIf config.terminal.enable {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    # home.packages = [
    #   pkgs.writeShellApplication
    #   {
    #     name = "rebuild";
    #     runtimeInputs = with pkgs; [ ];
    #     text = '''';
    #   }
    # ];

    programs.bat.enable = true;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
      };

      oh-my-zsh = {
        enable = true;
      };

      initContent = ''
        ZSH_THEME=""

        bindkey -v
        bindkey '^E' autosuggest-accept
        bindkey -M vicmd ' ' edit-command-line

        export MANPAGER="nvim +Man!"


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

        # Some fun stuff :))

        # fortune-kind | tee ~/fortune.txt | cowsay -s -f bong | tee ~/cowsay.txt

        # To remind myself what it's all about

        # Snippet to use fd to find the file, in case I move the file
        # fd --base-directory=Log4Stell 2026\ Resolutions

        sed '1 { /^---/ { :a N; /\n---/! ba; d} }' ~/Log4Stell/02-Permanent/2026-01-02T0118\ 2026\ Resolutions.md | bat -l=md -p
      '';
    };

    /*
         home.shell = {
        enableZshIntegration = true;
      };
    */

    home.shellAliases = {
      l = "eza -a --sort=type --group-directories-first";

      # Add an "alert" alias for long running commands.  Use like so:
      #   sleep 10; alert
      alert = ''
        notify-send --urgency=high -i "$([ $? = 0 ] && echo terminal || echo error)"
      '';

      pomodoro = ''
        timr-tui --log -w '25:00' -p '5:00' -m pomodoro --blink on --notification on
      '';

      # This was part of the above command, idk how to add it in again
      # TODO: Fix this and incorporate it back into the previous command

      # "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"

      icat = "kitten icat";
      cd = "z";
      c = "clear";
      ls = "eza";
      v = "nvim";
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
      enableGitIntegration = true;

      /*
           extraConfig = ''
          shell zsh
        '';
      */
    };

    programs.newsboat = {
      enable = true;
      autoReload = true;
      urls = [
        # TODO: Tag and make the urls pretty
        {
          url = "https://pwy.io/posts/feed.xml";
        }
        {
          url = "https://sgt.hootr.club/rss.xml";
        }
        {
          url = "https://mabez.dev/rss.xml";
        }
        {
          url = "https://jvns.ca/atom.xml";
        }
        {
          url = "https://drewdevault.com/blog/index.xml";
        }
        {
          url = "https://casualcompute.com/";
        }
        {
          url = "https://uncenter.dev/feed.xml";
        }
        {
          url = "https://stephango.com/feed.xml";
        }
        {
          url = "https://xeiaso.net/blog.rss";
        }
        {
          url = "https://artemis.sh/feed.xml";
        }
        {
          url = "https://www.sethdickinson.com/feed";
        }
        {
          url = "https://isabelroses.com/feed.xml";
        }
        {
          url = "https://www.0atman.com/feed.xml";
        }
        {
          url = "https://kglw.net/feed";
          title = "kglw.net";
          tags = [
            "music"
          ];
        }
        {
          url = "https://kglw.net/blog/feed";
          tags = [
            "music"
            "writing"
          ];
        }
        {
          url = "https://rosenzweig.io/feed.xml";
        }
        {
          url = "https://rust-gcc.github.io/feed.xml";
        }
        {
          url = "https://snowytrees.dev/blog/rss.xml";
          title = "Jordan Isaacs";
          tags = [
            "nix"
            "neovim"
            "programming"
          ];
        }
        {
          url = "https://readunderwire.com/feed";
        }
        {
          url = "https://blog.wesleyac.com/feed.xml";
        }
        {
          url = "https://woile.dev/rss.xml";
        }
        {
          url = "https://www.65daysofstatic.com/rss";
          title = "65daysofstatic";
          tags = [ "music" ];
        }
        {
          url = "https://scientificcomputing.rs/monthly/rss.xml";
          title = "Scientific Computing in Rust";
          tags = [
            "programming"
            "science"
            "rust"
          ];
        }
        {
          url = "https://cafkafk.dev/index.xml";
          title = "cafkafk";
          tags = [
            "programming"
            "rust"
            "nix"
            "personal"
          ];
        }
        {
          url = "http://www.aaronsw.com/weblog/index.xml";
          title = "Raw Thought";
          tags = [
            "programming"
            "activism"
          ];
        }
        {
          url = "https://lotsoflinks.substack.com//feed";
          title = "Lots of Links";
          tags = [
            "personal"
          ];
        }
        {
          url = "https://etymology.substack.com//feed";
          title = "The Etymology Nerd";
          tags = [
            "linguistics"
            "personal"
          ];
        }
        {
          url = "https://matklad.github.io/feed.xml";
          title = "matklad";
          tags = [
            "rust"
            "nix"
          ];
        }
      ];

      extraConfig = ''
        unbind-key k
        unbind-key j
        # unbind-key l
        # unbind-key h
        # unbind-key <Enter>

        bind k everywhere up
        bind j everywhere down
        # bind l open
        # bind h quit

        color background          white   default
        color listnormal          white   default
        color listfocus           black   white   bold
        color listnormal_unread   white   default bold
        color listfocus_unread    black   white   bold
        color title               black   white   bold
        color info                white   default bold
        color hint-key            white   default bold
        color hint-keys-delimiter white   default
        color hint-separator      white   default bold
        color hint-description    white   default
        color article             white   default
      '';
    };
  };
}
