{ config, pkgs, ... }:
let
  config_files = ./dotfiles;
  toConfigFile = file: (toString config_files + ("/" + file));
in {
  home.username = "dalli_server";
  home.homeDirectory = "/home/dalli_server";

  home.packages = with pkgs; [
    fastfetch
    ripgrep
    bat
    micro
    htop
    krabby
    ncdu
  ];
  programs.kitty = {
  enable = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

 initContent = ''

 bindkey "''${key[Up]}" up-line-or-search
      zstyle ':completion:*' menu no
      autoload -Uz compinit; compinit
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      krabby random
      # Eger terminal Kitty ise, sunucu uyumlulugu icin standart moda gec
      if [[ "$TERM" == "xterm-kitty" ]]; then
        export TERM=xterm-256color
      fi
    '';

    shellAliases = {
      ll = "ls -l";
      # Sistem güncelleme
      sys-switch = "sudo nix run --extra-experimental-features 'nix-command flakes' github:numtide/system-manager -- switch --flake /home/dalli_server/nix-config#default";
      # Kullanıcı güncelleme
      home-switch = "nix run --extra-experimental-features 'nix-command flakes' github:nix-community/home-manager -- switch --flake /home/dalli_server/nix-config#dalli_server";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "systemd" "docker" "fzf-tab" ];
      theme = "robbyrussell"; 
    };
  };
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    shortcut = "a";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      yank
      catppuccin
    ];
    extraConfig = ''
    bind-key y display-popup -w 100% -h 70% -E 'comm -23 <(tmux list-keys | sort) <(tmux -L test -f /dev/null list-keys | sort) | cut -c-"$(tput cols)" | fzf -e -i --prompt="tmux hotkeys: " --info=inline --layout=reverse --scroll-off=5 --tiebreak=index --header "prefix=yes-prefix root=no-prefix" > /dev/null'
      # vim style tmux config

      # use C-a, since it's on the home row and easier to hit than C-b
      set-option -g prefix C-a
      unbind-key C-a
      bind-key C-a send-prefix
      set -g base-index 1

      # vi is good
      setw -g mode-keys vi

      # mouse behavior
      setw -g mouse on

      set-option -g default-terminal screen-256color

      bind-key : command-prompt
      bind-key r refresh-client
      bind-key L clear-history

      bind-key space next-window
      bind-key bspace previous-window
      bind-key enter next-layout

      # use vim-like keys for splits and windows
      bind-key v split-window -h
      bind-key s split-window -v
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # smart pane switching with awareness of vim splits
      bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-h) || tmux select-pane -L"
      bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-j) || tmux select-pane -D"
      bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-k) || tmux select-pane -U"
      bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-l) || tmux select-pane -R"
      bind -n 'C-\' run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys 'C-\\') || tmux select-pane -l"
      bind C-l send-keys 'C-l'

      bind-key C-o rotate-window

      bind-key + select-layout main-horizontal
      bind-key = select-layout main-vertical

      set-window-option -g other-pane-height 25
      set-window-option -g other-pane-width 80
      set-window-option -g display-panes-time 1500
      set-window-option -g window-status-current-style fg=magenta

      bind-key a last-pane
      bind-key q display-panes
      bind-key c new-window
      bind-key t next-window
      bind-key T previous-window

      bind-key [ copy-mode
      bind-key ] paste-buffer

      # Setup 'v' to begin selection as in Vim
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # Status Bar
      set-option -g status-interval 1
      set-option -g status-style bg=black
      set-option -g status-style fg=white
      set -g status-left '#[fg=green]#H #[default]'
      set -g status-right '%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'

      set-option -g pane-active-border-style fg=yellow
      set-option -g pane-border-style fg=cyan

      # Set window notifications
      setw -g monitor-activity on
      set -g visual-activity on

      # Allow the arrow key to be used immediately after changing windows
      set-option -g repeat-time 0
      
      # theme
      set -g @catppuccin_flavour 'mocha'
    '';
  };

 programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
       show_banner: false,
       completions: {
       case_sensitive: false # case-sensitive completions
       quick: true    # set to false to prevent auto-selecting completions
       partial: true    # set to false to prevent partial filling of the prompt
       algorithm: "fuzzy"    # prefix or fuzzy
       external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           enable: true
       # set to lower can improve completion performance at the cost of omitting some options
           max_results: 100
           completer: $carapace_completer # check 'carapace_completer'
         }
       }
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      prepend /home/myuser/.apps |
      append /usr/bin/env
      )
    '';
  };
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.neovim = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    nvim_config_files = toConfigFile "nvim/lua/plugins";
    toLuaFile = file: "lua << EOF\n${builtins.readFile (toString nvim_config_files + ("/" + file))}\nEOF\n";
  in {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        # ALE
        plugin = ale;
        config = toLua "
               local g = vim.g
               g.ale_ruby_rubocop_auto_correct_all = 1
               g.ale_linters = {
                  ruby = {'rubocop', 'ruby'},
                  lua = {'lua_language_server'},
                  python = {'pylint'}
               }
            ";
      }
      {
        # Alpha
        plugin = alpha-nvim;
        config = toLua "require'alpha'.setup(require'alpha.themes.theta'.config)";
      }
      {
        # Oil
        plugin = oil-nvim;
        config = toLua ''
          local oil = require("oil")
          oil.setup()
          vim.keymap.set("n", "-", oil.toggle_float, {}) '';
      }
      {
        #Flash
        plugin = flash-nvim;
        config = toLua ''
          vim.keymap.set({'n', 'x', 'o'}, 's', function() require("flash").jump() end, { desc = 'Flash' })
          vim.keymap.set({'n', 'x', 'o'}, 'S', function() require("flash").treesitter() end, { desc = 'Flash Treesitter'})
          vim.keymap.set('o', 'r', function() require("flash").remote() end, { desc = 'Remote Flash' })
          vim.keymap.set({'x', 'o'}, 'R', function() require("flash").treesitter_search() end, { desc = 'Treesitter Search' })
          vim.keymap.set('c', '<c-s>', function() require("flash").toggle() end, { desc = 'Toggle Flash Search' })
        '';
      }
      {
        # Git Signs
        plugin = gitsigns-nvim;
        config = toLua ''
          require("gitsigns").setup()
          vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
          vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
        '';
      }
      {
        # vim-surround
        plugin = vim-surround;
        config =
          toLua ''
          '';
      }
      {
        #İndent Blankline
        plugin = indent-blankline-nvim;
        config = toLua ''
          local highlight = {
             "RainbowRed",
             "RainbowYellow",
             "RainbowBlue",
             "RainbowOrange",
             "RainbowGreen",
             "RainbowViolet",
             "RainbowCyan",
          }

          local hooks = require "ibl.hooks"
          -- create the highlight groups in the highlight setup hook, so they are reset
          -- every time the colorscheme changes
          hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
             vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
             vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
             vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
             vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
             vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
             vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
             vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          end)

          require("ibl").setup { indent = { highlight = highlight } }
        '';
      }
      {
        # Multiple Cursor
        plugin = vim-visual-multi;
        config = toLua ''vim.g.VM_leader = '<leader>m' '';
      }
      {
        # cmp-nvim-lsp
        plugin = cmp-nvim-lsp;
        config = toLua ''require('cmp').setup {sources = {{ name = 'nvim_lsp' }}} '';
      }
      {
        # LSP config
        plugin = nvim-lspconfig;
        config = toLua ''
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          local lspconfig = require("lspconfig")

          -- ts_ls
          vim.lsp.config('ts_ls', {
              capabilities = capabilities
          })
          vim.lsp.enable('ts_ls')

          -- solargraph
          vim.lsp.config('solargraph', {
              capabilities = capabilities
          })
          vim.lsp.enable('solargraph')

          -- html
          vim.lsp.config('html', {
              capabilities = capabilities
          })
          vim.lsp.enable('html')

          -- lua_ls
          vim.lsp.config('lua_ls', {
              capabilities = capabilities
          })
          vim.lsp.enable('lua_ls')

          -- nil_ls
          vim.lsp.config('nil_ls', {
              capabilities = capabilities
          })
          vim.lsp.enable('nil_ls')

          -- vhdl_ls
          vim.lsp.config('vhdl_ls', {
              on_attach = on_attach,
              capabilities = capabilities
          })
          vim.lsp.enable('vhdl_ls')

          -- svls
          vim.lsp.config('svls', {
              capabilities = capabilities
          })
          vim.lsp.enable('svls')

          -- pyright
          vim.lsp.config('pyright', {
              capabilities = capabilities
          })
          vim.lsp.enable('pyright')

          vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        '';
      }
      {
        # Nvim notify
        plugin = nvim-notify;
        config = toLua '''';
      }
      {
        # Diffview
        plugin = diffview-nvim;
        config = toLua ''require('diffview').setup({}) '';
      }

      {
        # Treesitter
        plugin = nvim-treesitter.withAllGrammars;
        config = toLua ''
          local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
          vim.fn.mkdir(parser_install_dir, "p")
          vim.opt.runtimepath:append(parser_install_dir)
          require('nvim-treesitter.config').setup({
             parser_install_dir = parser_install_dir,
             auto_install = true,
             highlight = { enable = true },
             indent = { enable = true },
          })
        '';
      }
      {
        # Which key
        plugin = which-key-nvim;
        config = toLua ''
          vim.o.timeout = true
          vim.o.timeoutlen = 10
          require("which-key").setup({})
          vim.keymap.set("n", "<leader>?",function() require("which-key").show({}) end, { desc = "Buffer Local Keymaps (which-key)" })
        '';
      }
      {
        # ToggleTerm
        plugin = toggleterm-nvim;
        config = toLua ''
          require("toggleterm").setup()
          vim.keymap.set("n", "<leader>t", '<cmd>ToggleTerm <CR>', { })
          function _G.set_terminal_keymaps()
            local opts = {buffer = 0}
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
          end
        '';
      }
      {
        # UFO
        plugin = nvim-ufo;
        config = toLua ''
          vim.opt.foldcolumn = '1'
          vim.opt.foldlevel = 99
          vim.opt.foldlevelstart = 99
          vim.opt.foldenable = true
          vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
          vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
          require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end
          })
        '';
      }
      {
        # comment
        plugin = comment-nvim;
        config = toLua ''require('Comment').setup()'';
      }
      
      {
        # Undotree
        plugin = undotree;
        config = toLua ''vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)'';
      }
      {
        # Bufferline
        plugin = bufferline-nvim;
        config = toLua ''require('bufferline').setup({}) '';
      }
      # {
      #   # cmp-cmdline
      #   plugin = cmp-cmdline;
      #   config = toLua ''
      #     cmp.setup.cmdline(':', {
      #       mapping = cmp.mapping.preset.cmdline(),
      #       sources = cmp.config.sources({
      #         { name = 'path' }
      #       }, {
      #         { name = 'cmdline' }
      #       }),
      #       matching = { disallow_symbol_nonprefix_matching = false }
      #     })
      #   '';
      # }
      {
        # catpuccin
        plugin = catppuccin-nvim;
        config = toLua ''vim.cmd.colorscheme "catppuccin-mocha"'';
      }
      {
        # conform
        plugin = conform-nvim;
        config = toLua ''
          require("conform").setup({
            formatters_by_ft = {
              lua = { "stylua" },
              -- Conform will run multiple formatters sequentially
              python = { "isort", "black" },
              -- You can customize some of the format options for the filetype (:help conform.format)
              rust = { "rustfmt", lsp_format = "fallback" },
              -- Conform will run the first available formatter
              javascript = { "prettierd", "prettier", stop_after_first = true },
              nix = { "alejandra" },
            },
          })
        '';
      }
      {
        # block
        plugin = block-nvim;
        config = toLua ''require("block").setup({})'';
      }

      # ToLuaFile
      plenary-nvim
      telescope-ui-select-nvim
      {
        plugin = telescope-nvim;
        config = toLuaFile "telescope.lua";
      }
      {
        plugin = neo-tree-nvim;
        config = toLuaFile "neo-tree.lua";
      }
      luasnip
      cmp_luasnip
      {
        plugin = nvim-cmp;
        config = toLuaFile "cmp.lua";
      }
    ];

    extraConfig = ''
      nnoremap <SPACE> <Nop>
      map <Space> <leader>
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
      set number
      set nobackup
      set noswapfile
      set autoread
      set spell
      set spelllang=en
      set cursorline
      set list
      set listchars=tab:>-,trail:•
      set clipboard=unnamedplus
      set ignorecase
      set smartcase
      set noswapfile
      set termguicolors
      set relativenumber
      set mouse=a
    '';

    initLua = ''

    '';
  };

programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.lazygit = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
  programs.git = {
    enable = true;
    settings.user.name = "DALLI-KAKTUS";
    settings.user.email = "berked2003@hotmail.com";
  };
  programs.yazi = {
    enable = true;
  };
    programs.btop.enable = true;
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    GSK_RENDERER = "gl";
  };
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
