{
  config,
  pkgs,
  inputs,
  ...
}: let
  config_files = ../dotfiles;
  toConfigFile = file: (toString config_files + ("/" + file)); # config dosyalarının konumlarını kolayca oluştur
in {
  home.username = "Kaktus";
  home.homeDirectory = "/home/Kaktus";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Bash
  programs.bash.enable = true;

  home.packages = with pkgs; [
    sl
    hello
    # Dev Tools
    qgroundcontrol
    arduino-ide
    arduino
    (python311.withPackages (ps: with ps; [ # python paketleri
      pyserial # esp32'nin çalışması için gerekli
      scipy
      pandas
      joblib
      tf-keras
      tensorflow
      keras
      matplotlib
      scikit-learn
    ]))
    gradle
    logisim
    logisim-evolution
    kicad
    xschem
    processing
    moreutils
    postgresql
    nodejs_22
    devenv
    gnome-maps
    distrobox
    p7zip
    ghdl
    gnumake
    gtkwave
    ttyplot
    gnuplot
    audacity
    # Multimedya
    #davinci-resolve
    kdenlive
    handbrake
    easyeffects
    mousai
    gimp
    inkscape
    krita
    obsidian
    lorien
    #cura
    orca-slicer
    blender
    freecad
    amberol
    clapper
    loupe
    vlc
    # Oyun ve Eğlence
    lutris
    spotify
    wireplumber
    # Ofis ve İletişim
    thunderbird
    discord
    libreoffice-fresh
    onlyoffice-desktopeditors
    zathura
    zoom-us
    localsend
    ferdium
    # unusefull
    peaclock
    cava
    figlet
    cowsay
    cbonsai
    waydroid
    mission-center
    exif
    # user interface
    connman
    cliphist
    font-manager
    opentabletdriver
    man-pages
    libqalculate
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
    #hyprland ui utils
    kdePackages.qt6ct
    dunst
    libnotify
    hyprshot
    bun
    dart-sass
    matugen
    swww
    hyprpicker
    wf-recorder
    wl-clipboard
    supergfxctl
    #fusion 360
    darling
    darling-dmg
    bottles
    wineWowPackages.full
    winetricks
    vulkan-tools
    # akademik
    mendeley

    # Language Servers
    ed
    nil
    alejandra
    vhdl-ls
    svls
  ];
  # Thunderbird Config
  home.file.".thunderbird" = {
    source = ../dotfiles/thunderbird;
    target = ".thunderbird";
    recursive = true;
  };
    # dunst 
  services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 200;
          offset = "30x50";
          origin = "top-right";
          transparency = 0;
          padding = 20;
          horizontal_padding = 20;
          frame_color = "#89b4fa";
          separator_color = "frame";
        };

        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        urgency_low = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        urgency_critical = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          frame_color = "#fab387";
        };
      };
    };
  # HYPRLAND CONFIG
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = ''
      ${builtins.readFile (toConfigFile "hypr/hyprland.conf")}
    '';
    plugins = with pkgs.hyprlandPlugins; [
      hyprfocus
      hyprspace
    ];
  };
  services.hyprpaper = {
    enable = false; #make it enable
    settings = {
      splash = true;
      preload = [(toConfigFile "hypr/cristmass.png")];
      wallpaper = [''eDP-1, ${toConfigFile "hypr/cristmass.png"}''];
    };
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
    ];
  };
  # Rofi config
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs;[
      #  rofi-calc
    ];
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg-col = mkLiteral "#1e1e2e";
          bg-col-light = mkLiteral "#1e1e2e";
          border-col = mkLiteral "#fab387";
          selected-col = mkLiteral "#f38ba8";
          blue = mkLiteral "#fab387"; # actually peach
          fg-col = mkLiteral "#cdd6f4";
          fg-col2 = mkLiteral "#f38ba8";
          grey = mkLiteral "#6c7086";
          width = 600;
        };

        "element-text, element-icon, mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          horizontal-align = mkLiteral "0.5"; 
        };
        "window" = {
          height = 360;
          border = 4;
          border-radius = 10;
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
          padding = mkLiteral "20px 20px 0px 20px";
        };
        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };
        "inputbar" = {
          children = mkLiteral "[prompt, entry]";
          background-color = mkLiteral "@blue";
          border-radius = 5;
          padding = 2;
        };
        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = 6;
          text-color = mkLiteral "@bg-col";
          border-radius = 3;
          margin = mkLiteral "0px 0px 0px 0px";
        };
        "textbox-prompt-colon" = {
          expand = false;
          str = ":";
        };
        "entry" = {
          padding = 6;
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };
        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 4;
          lines = 2;
          background-color = mkLiteral "@bg-col";
        };
        "element" = {
          padding = 10;
          orientation = mkLiteral "vertical";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
        };
        "element-icon" = {
          size = 60;
        };
        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@bg-col";
          border = 3;
          border-color = mkLiteral "@fg-col2";
          border-radius = 5;
        };
        "mode-switcher" = {
          spacing = 0;
        };
        "button" = {
          padding = 3;
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };
        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };
        "message" = {
          background-color = mkLiteral "@bg-col-light";
          margin = 2;
          padding = 2;
          border-radius = 5;
        };
        "textbox" = {
          padding = 6;
          margin = "20px 0px 0px 20px";
          text-color = mkLiteral "@blue";
          background-color = mkLiteral "@bg-col-light";
        };
      };
    extraConfig = {
      modi = "drun,window,filebrowser";
      icon-theme = "Adwaita";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 2;
      disable-history = false;
      hide-scrollbar = false;
      display-drun = "  Apps ";
      display-combi = "   Run ";
      display-window = " 󰕰  Window ";
      display-filebrowser = "   Files ";
      display-Network = " 󰤨  Network ";
      sidebar-mode = true;
      /* keys have to be unbound before they can be reused */
      kb-accept-entry = "Return,KP_Enter";
      kb-remove-to-eol = "";
      kb-remove-char-back = "BackSpace,Shift+BackSpace";
      kb-mode-complete = "";
      /* better vim controls */
      kb-row-down = "J,Ctrl+j,Alt+j,Down";
      kb-row-up = "K,Ctrl+k,Alt+k,Up";
      kb-row-left = "H,Ctrl+h,Alt+h";
      kb-row-right = "L,Ctrl+l,Alt+l";
      kb-mode-next = "Ctrl+w";
      kb-clear-line = "";
    };
  };
  # Waybar canfig disabled because most of the time i am using hyprpanel
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "custom/nix" "hyprland/workspaces" "custom/cava-internal"];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "backlight" "pulseaudio" "bluetooth" "network" "battery" ];

        "custom/nix" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "rofi -location 1 -show drun";
          "on-click-right" = "rofi -location 1 -show drun";
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "all-outputs" = true;
          "format-icons" = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六"; 
            "7" = "七"; 
            "8" = "八"; 
            "9" = "九"; 
            "10" = "十";
          };
        };
        "custom/cava-internal" = {
          "exec" = "sleep 1s && cava-internal";
          "tooltip" = false;
        };

        "clock" = {
          "format" = "<span color='#b4befe'> </span>{:%H.%M}";
          "tooltip" = true;
          "tooltip-format" = "{:%Y-%m-%d %a}";
        };

        "cpu" = { 
          "format" = "<span color='#b4befe'> </span>{usage}%"; 
          "on-click" = "missioncenter";
        };
        "memory" = {
          "interval" = 1;
          "format" = "<span color='#b4befe'> </span>{used:0.1f}G/{total:0.1f}G";
          "on-click" = "missioncenter";
        };
        "backlight" = {
          "device" = "intel_backlight";
          "format" = "<span color='#b4befe'>{icon}</span> {percent}%";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };
        "pulseaudio"= {
          "format" = "<span color='#b4befe'>{icon}</span> {volume}%";
          "format-muted" = "";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = "";
            "default" = ["" "" "󰕾" "󰕾" "󰕾" "" "" ""];
          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
        };
        "bluetooth" = {
          "format" = "<span color='#b4befe'></span> {status}";
          "format-disabled" = "";
          "format-connected" = "<span color='#b4befe'></span> {num_connections}";
          "tooltip-format" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}   {device_address}";
          "on-click" = "blueman-manager";
        };
        "network" = {
          "interface" = "wlp4s0";
          "format" = "{ifname}";
          "format-wifi" = "<span color='#b4befe'> </span>{essid}";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "format-disconnected" = "<span color='#b4befe'>󰖪 </span>No Network";
          "tooltip" = false;
        };
        "battery" = {
          "format" = "<span color='#b4befe'>{icon}</span> {capacity}%";
          "format-icons" =  ["" "" "" "" ""];
          "format-charging" = "<span color='#a6e3a1'></span> {capacity}%";
          "tooltip" = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        font-family: 'VictorMono Nerd Font Medium';
        font-size: 16px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        min-height: 30px;
      }

      window#waybar {
        background: transparent;
      }

      #custom-nix, 
      #workspaces {
        border-radius: 10px;
        background-color: #11111b;
        color: #fab387;
        margin-top: 1px;
        margin-right: 15px;
        padding-top: 1px;
        padding-left: 10px;
        padding-right: 10px;
      }

      #custom-nix {
        font-size: 20px;
        margin-left: 15px;
        color: #fab387;
      }

      #custom-cava-internal {
        padding-left: 10px;
        padding-right: 10px;
        padding-top: 1px;
        font-family: "Hack Nerd Font";
        color: #b4befe;
        background-color: #11111b;
        margin-top: 1px;
        border-radius: 10px;
      }

      #workspaces button.active {
        background:  #fab387;
        color: #11111b;
      }

      #clock, #backlight, #pulseaudio, #bluetooth, #network, #battery, #cpu, #memory{
        border-radius: 10px;
        background-color: #11111b;
        color: #cdd6f4;
        margin-top: 1px;
        padding-left: 10px;
        padding-right: 10px;
        margin-right: 15px;
      }

      #backlight, #bluetooth {
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
        padding-right: 5px;
        margin-right: 0
      }

      #pulseaudio, #network {
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;
        padding-left: 5px;
      }

      #clock {
        margin-right: 0;
      }
  '';
  };
  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  # zsh configuration
  # Zeoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';
    shellAliases = {
      ".." = "cd ..";
      ":q" = "exit";
      "re" = "echo sudo nixos-rebuild switch --flake /etc/nixos#default && sudo nixos-rebuild switch --flake /etc/nixos#default";
    };
    plugins = [
      {
        # will source vi-mode plugin
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
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
  # FZF Config
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  # Starship Config
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
  # Git Config
  programs.git = {
    enable = true;
    userName = "DALLI-KAKTUS";
    userEmail = "berked2003@hotmail.com";
  };
  # zellij config
  xdg.configFile."zellij/config.kdl".source = toConfigFile "zellij/config.kdl";
  xdg.configFile."zellij/layouts/default.kdl".source = toConfigFile "zellij/layouts/default.kdl";
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
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
        config = toLua ''
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
          lspconfig.ts_ls.setup({
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
          vim.opt.foldcolumn = '0'
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
        # Bufferline
        plugin = bufferline-nvim;
        config = toLua ''require('bufferline').setup({}) '';
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

    extraLuaConfig = ''

    '';
  };

  # YAZI File Manager
    programs.yazi = {
      enable =true;
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
      name = "VictorMono Nerd Font Medium";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_min_tabs = 2;
      tab_bar_edge = "top";
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
    font.name = "VictorMono Nerd Font Medium";
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
      active_tab_background   #fab387
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
    TERM = "kitty";
    EDITOR = "nvim";
    GSK_RENDERER = "gl";
  };

  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
