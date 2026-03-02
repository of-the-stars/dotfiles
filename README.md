# dotfiles

These are my personal dotfiles!

[[./.config/]] has all my actual config files for various apps. I used to symlink them using `stow`, but nowadays I have a little nested function and let `home-manager` take care of it using `xdg.configFile`. It's still `stow` compatible though!

[[./nixos/]] has all my Nix-related stuff. I don't use it to configure individual programs much unless it makes setting up `systemd` services or other such things easy. I personally prefer to use Nix as more of an "overlay" on top of normal POSIX stuff.

[[./spellbook/]] has a bunch of little scripts I've written to do various little tasks, like scanning the local network for named devices or automatically rebuilding my NixOS machine after editing the config. I usually stick them in `$PATH` by making them packages via `home-manager`, but using `stow` to symlink the spellbook itself as a kind of namespace works well too!

Currently my main machine is a Thinkpad T14 Gen5 with Niri as the compositor! I used to use Hyprland, but Niri is so much better in so many ways that I'm never going back. If you've never tried it before, I recommend it!
