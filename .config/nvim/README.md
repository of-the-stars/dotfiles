# of-the-stars's neovim configuration!

## Try it out!!

If you have nix installed, with the experimental flakes feature enabled, you can try my neovim config just by running

```shell
nix run 'github:of-the-stars/dotfiles?dir=.config/nvim'
```

## About

About as close to a "ground up" neovim config. Before this I was using
the AstroNvim distribution, which then broke on my NixOS machine.

My general (neo)vim journey has looked like:

```mermaid
  stateDiagram-v2
    s1 : Raw Vi Improved, fresh from Ubuntu's repos on my school's servers
    s2 : AstroNvim on my own personal laptop running Ubuntu
    s3 : That same AstroNvim config on my NixOS machine, which then broke
    s4 : A config built with nixCats-nvim (which eventually went into maintenance mode)
    s5 : The current config, a portable neovim wrapper built from the ground up to leverage the native package manager

    s1 --> s2
    s2 --> s3
    s3 --> s4
    s4 --> s5
```

I liked the idea of being able to declare my nvim config, and then run it with Nix. But I hated the idea of writing Lua, an already
unfamiliar language to me, in Nix strings without any formatting or LSP help. The [nixCats](https://github.com/BirdeeHub/nixCats-nvim)
project seemed like the answer to my prayers, but I was still learning flakes as a feature so it took me forever to be able to

1. Get it up and running
1. Actually adding it into my `configuration.nix` to run it and not have to enter an ephemral shell each time.

Couldn't let go of lazy.nvim to manage my plugins, so I went ahead with the [kickstart.vim](https://github.com/nvim-lua/kickstart.nvim)
template, which helped me better understand how to call plugin setups, write better lua for configs, and manage everything myself.
It very much feels like starting up NixOS for the first time, although having the previous experience from an opinionated, well-liked
distro like with Ubuntu or AstroNvim helped me figure out the workflow I wanted.

nixCats-nvim eventually went into maintenance mode, with Birdee pinting its users to move to [nix-wrapper-modules](https://github.com/nix-community/nix-wrapper-modules/tree/main). I tried it out, but it wasn't very easy to switch from LazyNvim to Birdee's own lze lazy loading framework.

Being inspired by more minimal neovim configurations, but also by the trend of just wrapping programs with their configs in Nix, I decided to write the current configuration from the ground up, wrapper and all. It was a fun exercise, and I'm happy with where I ended up.
