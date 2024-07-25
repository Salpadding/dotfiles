#!/usr/bin/env ruby

# access tmux variables through display-message command
def tmux_var(var)
  `tmux display-message -p '\#{#{var}}' | tr -d '\n\t '`
end

# handle C-h C-j with some magic 
if ['C-h', 'C-j', 'C-k', 'C-l'].any? { |x| x == ARGV[0] }
  actions = {
    'C-h' => ['left', '-L'],
    'C-j' => ['bottom', '-D'],
    'C-k' => ['top', '-U'],
    'C-l' => ['right', '-R'],
  }
  # <dir> ::= left | bottom | top | right
  dir = actions[ARGV[0]]

  # tty device of current tmux pane
  pane_tty = tmux_var 'pane_tty'

  # check if vim/neovim process is running at this pane
  # assuming vim/neovim should always be a foreground process
  if system("ps -t '#{pane_tty}' | sed 1d | awk '{print $NF}' | grep -iqE 'n?vim'") && ARGV[1] == nil
     # avoid recursion here
     `tmux send '#{ARGV[0]}'` 
      return
  end

  # check if current pane is located at boundary
  res = `tmux list-panes -F '\#{pane_at_#{dir[0]}}' -f '\#{pane_active}' | tr -d '\n\t '`
  if res == '1'
    return
  end
  `tmux select-pane #{dir[1]}`
end
