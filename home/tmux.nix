{pkgs-unstable, ...}: {
  programs.tmux = {
    enable = true;
    # tmux-256color has italics; kitty's RGB feature below gives nvim true colour
    terminal = "tmux-256color";
    shortcut = "a";
    keyMode = "vi";
    baseIndex = 1; # windows and panes
    mouse = true;
    focusEvents = true; # lets nvim's autoread notice changed files
    historyLimit = 10000;
    plugins = with pkgs-unstable.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          # same clock as before: weekday, 12-hour time with seconds, date
          set -g @catppuccin_date_time_text " %a %l:%M:%S %p %Y-%m-%d"
        '';
      }
    ];
    extraConfig = ''
      set -as terminal-features ",xterm-kitty:RGB"

      bind-key y display-popup -w 100% -h 70% -E 'comm -23 <(tmux list-keys | sort) <(tmux -L test -f /dev/null list-keys | sort) | cut -c-"$(tput cols)" | fzf -e -i --prompt="tmux hotkeys: " --info=inline --layout=reverse --scroll-off=5 --tiebreak=index --header "prefix=yes-prefix root=no-prefix" > /dev/null'
      # vim style tmux config

      # use C-a, since it's on the home row and easier to hit than C-b
      unbind-key C-a
      bind-key C-a send-prefix

      bind-key : command-prompt
      bind-key r refresh-client
      bind-key L clear-history

      bind-key space next-window
      bind-key bspace previous-window
      bind-key enter next-layout

      # use vim-like keys for splits and windows; new panes and windows open in the current directory
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key s split-window -v -c "#{pane_current_path}"
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # C-h/j/k/l/C-\ move between tmux panes and nvim splits (vim-tmux-navigator)
      # prefix C-l clears the screen
      bind C-l send-keys 'C-l'

      bind-key C-o rotate-window

      bind-key + select-layout main-horizontal
      bind-key = select-layout main-vertical

      set-window-option -g other-pane-height 25
      set-window-option -g other-pane-width 80
      set-option -g display-panes-time 1500

      bind-key a last-pane
      bind-key q display-panes
      bind-key c new-window -c "#{pane_current_path}"
      bind-key t next-window
      bind-key T previous-window

      bind-key [ copy-mode
      bind-key ] paste-buffer

      # Setup 'v' to begin selection as in Vim
      # (tmux talks to the macOS clipboard directly, reattach-to-user-namespace isn't needed)
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"

      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "pbcopy"
      # mouse selection goes to the clipboard too
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"

      # Status bar: catppuccin draws it; host on the left, clock on the right as before
      set-option -g status-interval 1
      set -g status-left "#{E:@catppuccin_status_host}"
      set -g status-right "#{E:@catppuccin_status_date_time}"

      # Set window notifications
      setw -g monitor-activity on
      set -g visual-activity on

      # Allow the arrow key to be used immediately after changing windows
      set-option -g repeat-time 0
    '';
  };
}
