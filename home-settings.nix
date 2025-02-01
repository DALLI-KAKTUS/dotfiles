{
  lib,
  pkgs,
  home-manager,
  ...
}: let
in {
  # default font SF Pro
  xdg.enable = true;
  # aliases
  home.shellAliases = {
      ".." = "cd ..";
      ":q" = "exit";
      "re" = "nix run nix-darwin -- switch --flake ~/Documents/nix/#macOS";
    };
  home.file.".hammerspoon" = {
    source = ./hammerspoon;
    recursive = true;
  };
}
