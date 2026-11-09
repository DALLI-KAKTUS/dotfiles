_: {
  imports = [
    ./packages.nix
    ./shell.nix
    ./nvim.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./opencode.nix
    ./apps.nix
    ./claude-code.nix
    ./qutebrowser.nix
    ./qalculate.nix
    ./vscode.nix
  ];

  xdg.enable = true;
  home = {
    # aliases
    shellAliases = {
      ".." = "cd ..";
      ":q" = "exit";
      "re" = "sudo darwin-rebuild switch --flake ~/Documents/nix#macOS";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
