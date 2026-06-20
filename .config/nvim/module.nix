{ wlib, config, pkgs, lib, ... }:
  imports = [ wlib.wrapperModules.neovim ];
  specs.general = with pkgs.vimPlugins; [
    # plugins which are loaded at startup ...
  ];
  specs.lazy = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      # plugins which are not loaded until you vim.cmd.packadd them ...
    ];
  };
  runtimePkgs = with pkgs; [
    # lsps, formatters, etc...
  ];
  settings.config_directory = ./.; # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
}
