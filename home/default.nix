{...}: {
  imports = [
    ./packages.nix
    ./shell.nix
    ./nvim.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
  ];

  # default font SF Pro
  xdg.enable = true;
  # aliases
  home.shellAliases = {
    ".." = "cd ..";
    ":q" = "exit";
    "re" = "sudo nix run nix-darwin -- switch --flake ~/Documents/nix/#macOS";
  };
  home.file.".hammerspoon" = {
    source = ../hammerspoon;
    recursive = true;
  };
  home.file.".qutebrowser".source = ../dotfiles/qutebrowser;

  home.sessionVariables = {
    EDITOR = "nvim";
    GSK_RENDERER = "gl";
  };
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
  home.stateVersion = "24.11";
}
