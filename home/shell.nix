{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    # compinit has to run before fzf-tab is sourced
    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      # fzf-tab replaces the completion menu
      zstyle ':completion:*' menu no
      autoload -Uz compinit && compinit
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    initContent = lib.mkMerge [
      # zsh-vi-mode resets key bindings when it initializes; doing that while it is
      # sourced (instead of on the first prompt) keeps fzf's Ctrl-R and the bindings below
      (lib.mkOrder 550 "ZVM_INIT_MODE=sourcing")
      ''
        # up/down arrow: search history for lines starting with what's typed
        autoload -U up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey '^[[A' up-line-or-beginning-search
        bindkey '^[OA' up-line-or-beginning-search
        bindkey '^[[B' down-line-or-beginning-search
        bindkey '^[OB' down-line-or-beginning-search

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        krabby random
      ''
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    icons = "always";
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      character = {
        success_symbol = "[🌵➜](bold green)";
        error_symbol = "[🌶️ ➜](bold red)";
      };
    };
  };
  programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
      let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }
      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false # case-sensitive completions
          quick: true # set to false to prevent auto-selecting completions
          partial: true # set to false to prevent partial filling of the prompt
          algorithm: "fuzzy" # prefix or fuzzy
          external: {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true
            # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100
            completer: $carapace_completer # check 'carapace_completer'
          }
        }
      }
    '';
  };
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.lazygit.enable = true;
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
  };
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      proc_sorting = "memory";
      update_ms = 2000;
    };
  };
}
