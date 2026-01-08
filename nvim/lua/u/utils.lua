local M = {
    -- fp, for functional programming
    fp = {
        id = function(x) return x end,

        compose = function(...)
            return vim.iter({ ... }):fold(nil,
                function(acc, item)
                    if not acc then return item end
                    return function(...)
                        local ret = acc(...)
                        return item(ret)
                    end
                end
            )
        end,

        eq = function(x, y) return x == y end,

        noop = function() end,
    },
    -- lua utils
    lua = {},
    -- buffer utils
    buf = {},
    -- tab utils
    tab = {},
    tmux = {},
    bool = function(val)
        if val == nil then return false end
        if type(val) == 'string' then return #val > 0 end
        if type(val) == 'number' then return val ~= 0 end
        if type(val) == 'boolean' then return val end
        return true
    end,
    -- file system utils
    fs = {
        read_file = function(path)
            local a = require "plenary.async"
            local err, fd, stat, data
            err, fd = a.uv.fs_open(path, "r", 438)
            if err then
                a.uv.fs_close(fd)
                return
            end

            err, stat = a.uv.fs_fstat(fd)
            if err or stat.type ~= "file" then return end

            err, data = a.uv.fs_read(fd, stat.size, 0)
            if err then return end
            a.uv.fs_close(fd)
            return data
        end,

        is_file = function(path)
            if not pasync then return false end
            local a = pasync
            local err, stat = a.uv.fs_stat(path)
            if err then return false end
            return stat and stat.type == "file"
        end
    }

}


M.fp.chain = function(...)
    return vim.iter({ ... }):rev():fold(M.fp.id,
        function(acc, item)
            return function(x)
                return item(x, acc)
            end
        end)
end


-- lua utils
M.lua.load_m = function(path)
    if not M.fs.is_file(path) then
        print("missing " .. path)
        return
    end

    local fn = loadfile(path)
    local m
    if fn ~= nil and vim.is_callable(fn) then m = fn() end
    return m
end

-- concat lists
M.lua.concat = function(...)
    return vim.iter({ ... }):flatten():totable()
end

M.fp.bind = function(fn, ...)
    local vars = { ... }
    return function(...)
        local merged = M.lua.concat(vars, { ... })
        return fn(unpack(merged))
    end
end


M.buf.cur = vim.api.nvim_get_current_buf

M.buf.get_opt = function(buf, opt_name)
    buf = buf or M.buf.cur()
    return vim.api.nvim_get_option_value(opt_name, { buf = buf })
end

M.buf.set_opt = function(buf, opt_name, value)
    buf = buf or M.buf.cur()
    vim.api.nvim_set_option_value(opt_name, value, { buf = buf })
end

M.buf.call = function(buf, fn)
    assert(vim.is_callable(fn), 'should be function')
    vim.api.nvim_buf_call(buf, fn)
end

M.buf.cmd = function(buf, cmd)
    M.buf.call(buf, M.fp.bind(vim.cmd, cmd))
end

M.buf.is_valid = vim.api.nvim_buf_is_valid

-- save buffer to disk
M.buf.save = function(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    if not M.buf.get_opt(buf, "modified") then
        return
    end

    M.buf.cmd(buf, "write")
end

M.buf.replace = function(bufnr, text)
    vim.fn.deletebufline(bufnr, 1, '$')
    local lines = vim.fn.split(text, "\n")
    vim.fn.appendbufline(bufnr, 0, lines)
end

M.tab.cur = vim.api.nvim_get_current_tabpage

M.tab.list_wins = function(tab)
    return vim.api.nvim_tabpage_list_wins(tab)
end


M.tmux.is_zoomed = function()
    local obj = vim.system({ "tmux", "lsw", "-F", "#F" }, { text = true }):wait()
    local lines = vim.fn.split(obj.stdout, "[\\n\\r]\\+")
    return vim.iter(lines):map(vim.fn.trim):any(function(line)
        return vim.fn.stridx(line, "*") >= 0
            and vim.fn.stridx(line, "Z") >= 0
    end)
end

M.tmux.select_pane = function(key)
    vim.schedule(
        function()
            vim.system({ os.getenv("HOME") .. "/.config/tmux/plugin.rb", "C-" .. key, "nvim" })
        end
    )
end

M.tmux.smart_wincmd = function(key)
    -- current window id
    local cur = vim.fn.win_getid()
    vim.cmd "stopinsert"
    vim.cmd(string.format("wincmd %s", key))
    if key == "c" then return end
    local after = vim.fn.win_getid()
    if after ~= cur then return end


    -- if after == cur, we may went to the boundary between neovim and tmux
    -- check if we are in tmux
    local term = vim.fn.getenv('TERM')
    if not vim.startswith(term, 'tmux') then return end

    vim.schedule(function()
        if M.tmux.is_zoomed() then return end
        M.tmux.select_pane(key)
    end)
end

return M
