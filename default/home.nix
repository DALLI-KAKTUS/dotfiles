{
  config,
  pkgs,
  inputs,
  ...
}: 
let
  config_files = ../dotfiles;
  toConfigFile = file: (toString config_files + ("/" + file));
in {
  imports = [ inputs.ags.homeManagerModules.default ];
  home.username = "Kaktus";
  home.homeDirectory = "/home/Kaktus";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Bash
  programs.bash.enable = true;
  # Zeoxide
  programs.zoxide = {
  enable = true;
  enableZshIntegration = true;
  options = [
  "--cmd cd"
  ];
  };
  home.packages = with pkgs; [
    sl
    hello
    # Dev Tools
    arduino-ide
    arduino
    gradle
    logisim
    logisim-evolution
    processing
    postgresql
    kicad-small
    nodejs_22
    devenv
    gnome.gnome-maps
    # bat
    # Multimedya
    blender
    #davinci-resolve
    gimp
    inkscape
    obsidian
    cura
    freecad
    amberol
    clapper
    loupe
    vlc
    # Oyun ve Eğlence
    lutris
    spotify
    steam
    obs-studio
    wireplumber
    pipewire
    # Ofis ve İletişim
    thunderbird
    discord
    libreoffice-qt
    zathura
    zoom-us
    # unusefull
    cava
    figlet
    cowsay
    cbonsai
    waydroid
    mission-center
    # user interface
    cliphist
    font-manager
    opentabletdriver
    man-pages
    python3
    qalculate-qt
    libsForQt5.qt5ct
    qutebrowser
    ripgrep
    ripgrep-all
    xwaylandvideobridge
    zerotierone
    starship
    wl-clipboard
    bat
    xdragon
    wl-clipboard
    kitty
    #hyprland ui utils
    kdePackages.qt6ct
    hyprpaper
    xdg-desktop-portal-hyprland
    dunst
    hyprshot
    bun
    dart-sass
    matugen
    swww
    hyprpicker
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    supergfxctl
    #fusion 360
    bottles
    wine64
    winetricks
    vulkan-tools
    # Language Servers
    ed
    nil
    alejandra
    vhdl-ls
    svls
  ];
  home.file.".thunderbird" = {
  source = ../dotfiles/thunderbird;
  target = ".thunderbird";
  recursive = true;
  };

  # HYPRLAND CONFIG
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      extraConfig = ''
        ${builtins.readFile (toConfigFile "hypr/hyprland.conf")}
      '';
      plugins = with pkgs.hyprlandPlugins; [
        # hyprfocus
        # hyprbars
      ];
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = true;
        preload = [(toConfigFile "hypr/wallpaper.png")];
        wallpaper = [''eDP-1, ${toConfigFile "hypr/wallpaper.png"}''];
      };
    };
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = toConfigFile "ags";

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

  # direnv
  programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  # zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    completionInit = ''
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 
    zstyle ':completion:*' menu select 
    '';
    shellAliases = {
      ".." = "cd ..";
      "re" = "echo sudo nixos-rebuild switch --flake /etc/nixos#default && sudo nixos-rebuild switch --flake /etc/nixos#default";
    };
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
    ];
    initExtra = ''
    bindkey "''${key[Up]}" up-line-or-search
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    '';
  };
  programs.fzf={
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
  programs.git = {
  enable = true;
  userName  = "DALLI-KAKTUS";
  userEmail = "berked2003@hotmail.com";
  };

  # Nvim configuration
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
        # Buffer line
        plugin = bufferline-nvim;
        config = toLua "require('bufferline').setup{}";
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
          lspconfig.tsserver.setup({
             capabilities = capabilities})
          lspconfig.solargraph.setup({
             capabilities = capabilities})
          lspconfig.html.setup({
             capabilities = capabilities})
          lspconfig.lua_ls.setup({
             capabilities = capabilities})
          lspconfig.nil_ls.setup({
             capabilities = capabilities})
          lspconfig['vhdl_ls'].setup({
            on_attach = on_attach,
            capabilities = capabilities
          })
          lspconfig.svls.setup({
            capabilities = capabilities
          })

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
        # Oil
        plugin = oil-nvim;
        config = toLua ''
          local oil = require("oil")
          oil.setup()
          vim.keymap.set("n", "-", oil.toggle_float, {}) '';
      }
      {
        # Treesitter
        plugin = nvim-treesitter.withAllGrammars;
        config = toLua ''
          local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
          vim.fn.mkdir(parser_install_dir, "p")
          vim.opt.runtimepath:append(parser_install_dir)
          require('nvim-treesitter.configs').setup({
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
        # spectre
        plugin = nvim-spectre;
        config = toLua ''
          vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
              desc = "Toggle Spectre"
          })
          vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
              desc = "Search current word"
          })
          vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
              desc = "Search current word"
          })
          vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
              desc = "Search on current file"
          })
        '';
      }
      {
        # Undotree
        plugin = undotree;
        config = toLua ''vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)'';
      }
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

    extraLuaConfig = ''

    '';
  };
  
  # LF configuration
  xdg.configFile."lf/icons".source = toConfigFile "lf/icons" ;
  xdg.configFile."lf/colors".source = toConfigFile "lf/colors" ;
  programs.lf = {
      # icons file setup
      enable = true;
      commands = {
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
        '';
      };
      keybindings = {
        "\\\"" = "";
        o = "";
        c = "mkdir";
        "." = "set hidden!";
        "`" = "mark-load";
        "\\'" = "mark-load";
        "<enter>" = "open";
        do = "dragon-out";
        "g~" = "cd";
        gh = "cd";
        "g/" = "/";
        ee = "editor-open";
        V = ''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
      };
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
        ifs = "\n";
      };
      # previewer setup
      extraConfig = 
        let 
          previewer = 
            pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5
            
            if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                exit 1
            fi
            
            ${pkgs.pistol}/bin/pistol "$file"
          '';
          cleaner = pkgs.writeShellScriptBin "clean.sh" ''
            ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        in
        ''
          set cleaner ${cleaner}/bin/clean.sh
          set previewer ${previewer}/bin/pv.sh
        '';
      };
  # GTK configuration
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.google-cursor;
      name = "GoogleDot-Red";
      size = 24;
    };
    font = {
      name = "VictorMono Nerd Font";
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
    };
    gtk3.extraConfig = {
    gtk-application-prefer-dark-theme=1;
    };
    gtk4.extraConfig = {
    gtk-application-prefer-dark-theme=1;
    };
  };
  qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
  };
  programs.kitty ={
    enable = true;
    settings = {
    tab_bar_min_tabs = 1;
    tab_bar_edge = "bottom";
    tab_bar_style = "powerline";
    tab_powerline_style = "slanted";
    tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    cursor_shape = "block";
    cursor_blink_interval = -1;
    cursor_stop_blinking_after = 15;
    strip_trailing_spaces = "smart";
    url_prefixes = "http https gemini";
    url_style = "curly";
    background_opacity = "0.8";
    };
    font.name = "VictorMono Nerd Font";
    font.size = 14;
    shellIntegration.enableZshIntegration = true;
    extraConfig = ''
      # The basic colors
      foreground              #cdd6f4
      background              #1e1e2e
      selection_foreground    #1e1e2e
      selection_background    #f5e0dc

      # Cursor colors
      cursor                  #f5e0dc
      cursor_text_color       #1e1e2e

      # URL underline color when hovering with mouse
      url_color               #f5e0dc

    # Kitty window border colors
    active_border_color     #b4befe
    inactive_border_color   #6c7086
    bell_border_color       #f9e2af

    # OS Window titlebar colors
    wayland_titlebar_color system
    macos_titlebar_color system

    # Tab bar colors
    active_tab_foreground   #11111b
    active_tab_background   #cba6f7
    inactive_tab_foreground #cdd6f4
    inactive_tab_background #181825
    tab_bar_background      #11111b

    # Colors for marks (marked text in the terminal)
    mark1_foreground #1e1e2e
    mark1_background #b4befe
    mark2_foreground #1e1e2e
    mark2_background #cba6f7
    mark3_foreground #1e1e2e
    mark3_background #74c7ec

    # The 16 terminal colors

    # black
    color0 #45475a
    color8 #585b70

    # red
    color1 #f38ba8
    color9 #f38ba8

    # green
    color2  #a6e3a1
    color10 #a6e3a1

    # yellow
    color3  #f9e2af
    color11 #f9e2af

    # blue
    color4  #89b4fa
    color12 #89b4fa

    # magenta
    color5  #f5c2e7
    color13 #f5c2e7

    # cyan
    color6  #94e2d5
    color14 #94e2d5

    # white
    color7  #bac2de
    color15 #a6adc8
    '';
  };
    
  # QuteBrowser config
    xdg.configFile."qutebrowser/config.py".source = toConfigFile "qutebrowser/config.py";
  # Btop configuration
    # xdg.configFile."btop/btop.conf".source = toConfigFile "btop/btop.conf";
    

  # Cava Configuration
  # programs.cava= {
  #   enable = true;
  #   settings = {
  #       background = "'#000000'";
  #       foreground = "'#FFFFFF'";
  #       color.gradient = "1";
  #       gradient_color_1 = "'#DB2DEE'";
  #       gradient_color_2 = "'#E23CBF'";
  #       gradient_color_3 = "'#E94B8F'";
  #       gradient_color_4 = "'#F15A60'";
  #       gradient_color_5 = "'#F86930'";
  #       gradient_color_6 = "'#FF7801'";
  #       gradient_color_7 = "'#FF5805'";
  #       gradient_color_8 = "'#FF0505'";
  #   };
  # };
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
