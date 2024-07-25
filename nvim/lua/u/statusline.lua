-- statusline:
-- buffer:
-- full file path
-- file type, shiftwidth, modified at
-- auto save status, dirty or synced
-- total line numbers, current line numbers

-- tabline:
-- working directory,
local utils = require "u.utils"
local bind = utils.fp.bind

local ringbuf = {
    keys = {},
    tail = 0,
    len = 0,
    max = 16,
}

ringbuf.add = function(self, key)
    if key == nil then return end
    self.tail = self.tail + 1
    self.len = self.len + 1
    self.keys[self.tail] = key
    self:shrink()
end

ringbuf.shrink = function(self)
    if self.len <= self.max then return end
    local head = self.tail - self.len + 1
    table.remove(self.keys, head)
    self.len = self.len - 1
end

ringbuf.format = function(self)
    if self.len <= 0 then return '' end
    local formated = {}
    local head = self.tail - self.len + 1

    for i = head, self.tail do
        table.insert(formated, vim.fn.keytrans(self.keys[i]))
    end
end


vim.on_key(bind(ringbuf.add, ringbuf))

return bind(ringbuf.format, ringbuf)
