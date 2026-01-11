local defaults = require "u.defaults"
local utils = require "u.utils"

-- Disable netrw early if using nvim-tree (must be before any plugins load)
if defaults.options.nvim_tree then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

-- configure clipboard (OSC 52 for copy, tmux refresh-client for paste)
-- Store linewise content to detect register type during paste
local linewise_content = nil
local last_regtype = nil

-- Debug command: :ClipboardDebug
vim.api.nvim_create_user_command('ClipboardDebug', function()
  vim.fn.system('tmux refresh-client -l')
  local clipboard = vim.fn.system('tmux save-buffer -'):gsub('\n$', '')
  print('linewise_content: ' .. vim.inspect(linewise_content))
  print('last_regtype: ' .. vim.inspect(last_regtype))
  print('clipboard: ' .. vim.inspect(clipboard))
  print('match: ' .. tostring(linewise_content == clipboard))
end, {})

local function make_copy_fn(reg)
  local osc52_copy = require('vim.ui.clipboard.osc52').copy(reg)
  return function(lines, regtype)
    last_regtype = regtype
    -- Store content if linewise (strip trailing newline to match clipboard)
    if regtype == 'V' then
      linewise_content = table.concat(lines, '\n'):gsub('\n$', '')
    else
      linewise_content = nil
    end
    return osc52_copy(lines, regtype)
  end
end

local function make_paste_fn(cmd)
  return function()
    local content = vim.fn.system(cmd):gsub('\n$', '') -- trim trailing newline
    local lines = vim.split(content, '\n', { plain = true })
    -- Check if content matches stored linewise content
    local regtype = (linewise_content and content == linewise_content) and 'V' or 'v'
    return { lines, regtype }
  end
end

local function get_paste_fn()
  if vim.fn.has('mac') == 1 then
    return make_paste_fn('pbpaste')
  elseif vim.env.TMUX then
    return function()
      vim.fn.system('tmux refresh-client -l')
      local content = vim.fn.system('tmux save-buffer -'):gsub('\n$', '')
      local lines = vim.split(content, '\n', { plain = true })
      local regtype = (linewise_content and content == linewise_content) and 'V' or 'v'
      return { lines, regtype }
    end
  elseif vim.env.DISPLAY and vim.fn.executable('xclip') == 1 then
    return make_paste_fn('xclip -selection clipboard -o')
  elseif vim.env.WAYLAND_DISPLAY and vim.fn.executable('wl-paste') == 1 then
    return make_paste_fn('wl-paste')
  end
end

vim.g.clipboard = {
  name = 'OSC 52 + tmux refresh',
  copy = {
    ['+'] = make_copy_fn('+'),
    ['*'] = make_copy_fn('*'),
  },
  paste = {
    ['+'] = get_paste_fn(),
    ['*'] = get_paste_fn(),
  },
}

-- global options
vim.cmd.source(
    vim.fs.joinpath(
        vim.fn.stdpath("config"),
        "opts.vim"
    )
)

require "u.lazy"

vim.api.nvim_set_keymap("n", "q", "", {
    noremap = true,
    callback = function()
        if utils.buf.get_opt(0, "buftype") == "terminal" then
            vim.fn.feedkeys('i', 'n')
            return
        end
        vim.fn.feedkeys('q', 'n')
    end
})

vim.iter({ "n", "t" }):each(
    function(mode)
        vim.iter({ "h", "j", "k", "l", "c" }):each(function(key)
            if mode == "t" and key == "c" then return end
            vim.api.nvim_set_keymap(mode, string.format("<C-%s>", key), "",
                { noremap = true, callback = utils.fp.bind(utils.tmux.smart_wincmd, key) })
        end)
    end
)




-- autocommands
require "u.au"

-- custom commands
require "u.cmd"
require "u.netrw"
