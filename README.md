# dotfiles

My personal dotfiles! My main machine is a Thinkpad T14 Gen 5,
currently running NixOS with Hyprland as the window manager.

I recently did a big overhaul, and finally unlocked the full powers of 
flakes and home-manager, making my config 100% reproducible.

I got rid of all the imperative and impure aspects, like nix channels
and `stow` to manage my dotfiles, so everything should be 100% reproducible 
using a single pull and script.

## Getting started

*This config assumes that the repo is getting pulled into a directory named `dotfiles`*

First, clone the repo into your home directory.

Second, navigate into the directory and run `./rebuild.sh`. This will build up the
whole configuration 100% automatically and on its own.
