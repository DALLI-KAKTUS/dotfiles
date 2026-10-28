{pkgs, ...}: let
  nvim_config_files = ../dotfiles/nvim/lua/plugins;
  toLuaFile = file: "lua << EOF\n${builtins.readFile (nvim_config_files + "/${file}")}\nEOF\n";
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        # Treesitter
        # nvim-treesitter's main branch only ships parsers/queries,
        # highlighting is started by neovim itself
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
              pcall(vim.treesitter.start, args.buf)
            end,
          })
        '';
      }
      {
        # ALE
        plugin = ale;
        type = "lua";
        config = ''
          local g = vim.g
          g.ale_ruby_rubocop_auto_correct_all = 1
          g.ale_linters = {
             ruby = {'rubocop', 'ruby'},
             lua = {'lua_language_server'},
             python = {'pylint'}
          }
        '';
      }
      {
        # Alpha
        plugin = alpha-nvim;
        type = "lua";
        config = "require'alpha'.setup(require'alpha.themes.theta'.config)";
      }
      {
        # Oil
        plugin = oil-nvim;
        type = "lua";
        config = ''
          local oil = require("oil")
          oil.setup()
          vim.keymap.set("n", "-", oil.toggle_float, {})
        '';
      }
      {
        # Flash
        plugin = flash-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
          require("gitsigns").setup()
          vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
          vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
        '';
      }
      vim-surround
      {
        # Indent Blankline
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''vim.g.VM_leader = '<leader>m' '';
      }
      cmp-nvim-lsp
      {
        # LSP config (servers come from home.packages)
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          vim.lsp.config('*', {
              capabilities = require('cmp_nvim_lsp').default_capabilities()
          })
          vim.lsp.enable({
              'ts_ls',
              'solargraph',
              'html',
              'lua_ls',
              'nil_ls',
              'vhdl_ls',
              'svls',
              'pyright',
          })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        '';
      }
      nvim-notify
      {
        # Diffview
        plugin = diffview-nvim;
        type = "lua";
        config = ''require('diffview').setup({})'';
      }
      {
        # Which key
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          vim.o.timeout = true
          vim.o.timeoutlen = 10
          require("which-key").setup({})
          vim.keymap.set("n", "<leader>?",function() require("which-key").show({}) end, { desc = "Buffer Local Keymaps (which-key)" })
        '';
      }
      {
        # ToggleTerm
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = ''
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
        # Comment
        plugin = comment-nvim;
        type = "lua";
        config = ''require('Comment').setup()'';
      }
      {
        # Undotree
        plugin = undotree;
        type = "lua";
        config = ''vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)'';
      }
      {
        # Bufferline
        plugin = bufferline-nvim;
        type = "lua";
        config = ''require('bufferline').setup({})'';
      }
      # {
      #   # cmp-cmdline
      #   plugin = cmp-cmdline;
      #   type = "lua";
      #   config = ''
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
        # Catppuccin
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''vim.cmd.colorscheme "catppuccin-mocha"'';
      }
      {
        # Conform
        plugin = conform-nvim;
        type = "lua";
        config = ''
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
        # Block
        plugin = block-nvim;
        type = "lua";
        config = ''require("block").setup({})'';
      }
      plenary-nvim
      telescope-ui-select-nvim
      {
        # Telescope
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup({
            extensions = {
              ["ui-select"] = {
                require("telescope.themes").get_dropdown({}),
              },
            },
          })
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<C-p>", builtin.find_files, {})
          vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
          vim.keymap.set("n", "<leader><leader>", builtin.builtin, {})

          require("telescope").load_extension("ui-select")
        '';
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
      set relativenumber
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
      set termguicolors
      set mouse=a
    '';
  };
}
