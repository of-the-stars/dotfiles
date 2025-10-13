# dotfiles

My personal dotfiles! My main machine is a Thinkpad T14 Gen 5,
currently running NixOS with Hyprland as the window manager.

I recently did a big overhaul, and finally unlocked the full powers of
flakes and home-manager, making my config 87% reproducible. I have done
some minimal testing, with limited success, but I have some kinks to work
out.

I got rid of all the imperative and impure aspects, like nix channels
and `stow` to manage my dotfiles, so everything should be 100% reproducible
using a single pull and script.
