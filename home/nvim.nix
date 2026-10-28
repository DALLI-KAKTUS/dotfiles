{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # defaults changed to false in home-manager 26.05, keep the providers
    withPython3 = true;
    withRuby = true;

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
        # Snacks: picker (also vim.ui.select), terminal, notifications
        plugin = snacks-nvim;
        type = "lua";
        config = ''
          require("snacks").setup({
            picker = { enabled = true },
            terminal = { enabled = true },
            notifier = { enabled = true },
          })
          vim.keymap.set("n", "<C-p>", function() Snacks.picker.files() end, { desc = "Find files" })
          vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep" })
          vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.pickers() end, { desc = "Pickers" })
          vim.keymap.set("n", "<leader>t", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })
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
      {
        # Surround: same ys/ds/cs and visual S keys as vim-surround
        # (set up after flash so visual S stays surround, like before)
        plugin = nvim-surround;
        type = "lua";
        config = ''require("nvim-surround").setup()'';
      }
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
        # Multiple Cursor (keys kept close to vim-visual-multi)
        plugin = multicursor-nvim;
        type = "lua";
        config = ''
          local mc = require("multicursor-nvim")
          mc.setup()
          local set = vim.keymap.set
          set({"n", "x"}, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
          set({"n", "x"}, "<C-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
          set({"n", "x"}, "<C-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
          set({"n", "x"}, "<leader>mA", mc.matchAllAddCursors, { desc = "Add cursors at all matches" })
          set("n", "<c-leftmouse>", mc.handleMouse)
          set("n", "<c-leftdrag>", mc.handleMouseDrag)
          set("n", "<c-leftrelease>", mc.handleMouseRelease)
          -- only while there are multiple cursors
          mc.addKeymapLayer(function(layerSet)
            layerSet({"n", "x"}, "q", function() mc.matchSkipCursor(1) end)
            layerSet({"n", "x"}, "Q", mc.deleteCursor)
            layerSet("n", "<esc>", function()
              if not mc.cursorsEnabled() then
                mc.enableCursors()
              else
                mc.clearCursors()
              end
            end)
          end)
        '';
      }
      {
        # LSP config (servers come from home.packages)
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          vim.lsp.config('*', {
              capabilities = require('blink.cmp').get_lsp_capabilities()
          })
          -- typescript-language-server doesn't bundle typescript
          vim.lsp.config('ts_ls', {
              init_options = {
                  tsserver = { path = "${pkgs.typescript}/lib/node_modules/typescript/lib" }
              }
          })
          vim.lsp.config('lua_ls', {
              settings = { Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } } }
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
      {
        # Completion
        plugin = blink-cmp;
        type = "lua";
        config = ''
          require("luasnip.loaders.from_vscode").lazy_load()
          require("blink.cmp").setup({
            -- <CR> accepts, <C-Space> opens, <C-e> closes, <C-b>/<C-f> scroll docs
            keymap = { preset = "enter" },
            snippets = { preset = "luasnip" },
            sources = { default = { "lsp", "snippets" } },
            completion = {
              menu = { border = "rounded" },
              documentation = { auto_show = true, window = { border = "rounded" } },
            },
          })
        '';
      }
      luasnip
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
          vim.o.timeoutlen = 300
          require("which-key").setup({})
          vim.keymap.set("n", "<leader>?",function() require("which-key").show({}) end, { desc = "Buffer Local Keymaps (which-key)" })
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
        # tmux/nvim pane navigation with C-h/j/k/l
        plugin = vim-tmux-navigator;
        type = "lua";
        config = "";
      }
      plenary-nvim
      {
        # Neo-tree
        plugin = neo-tree-nvim;
        type = "lua";
        config = builtins.readFile ../dotfiles/nvim/lua/plugins/neo-tree.lua;
      }
    ];

    # commenting: built-in gc / gcc (nvim >= 0.10)
    extraConfig = ''
      let mapleader = " "
      nnoremap <SPACE> <Nop>
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
