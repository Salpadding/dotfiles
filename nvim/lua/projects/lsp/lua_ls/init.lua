return {
  on_init = function(client)
    local wf = client.workspace_folders
    local path = wf and wf[1] and wf[1].name or nil
    if path
      and (vim.uv.fs_stat(path .. "/.luarc.json")
        or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
    then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    })
  end,
  settings = { Lua = {} },
}
