#!/usr/bin/env ruby

# access tmux variables through display-message command
def tmux_var(var)
  `tmux display-message -p '\#{#{var}}'`.strip
end

# handle C-h C-j with some magic 
exit 0 unless ['C-h', 'C-j', 'C-k', 'C-l'].any? { |x| x == ARGV[0] }

actions = {
  'C-h' => ['left', '-L'],
  'C-j' => ['bottom', '-D'],
  'C-k' => ['top', '-U'],
  'C-l' => ['right', '-R'],
}
# <dir> ::= left | bottom | top | right
dir = actions[ARGV[0]]

# check if vim/neovim process is running at this pane
pane_cmd = tmux_var('pane_current_command').downcase
if pane_cmd.match?(/n?vim/) && ARGV[1].nil?
    # avoid recursion here
    `tmux send '#{ARGV[0]}'` 
    return
end

# check if current pane is located at boundary
res = `tmux list-panes -F '\#{pane_at_#{dir[0]}}' -f '\#{pane_active}'`.strip
if res == '1'
  return
end
`tmux select-pane #{dir[1]}`