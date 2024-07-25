# vim/neovim 笔记

## normal 模式下常见的操作

`#`: search backward

`*`: search forward

`CTRL-W +` or `:res +1`: increase window height

`CTRL-W -` or `:res -1`: decrease window height

`:res 30`: set window height

`CTRL-W <` or `:vert res -1`: decrease window width

`CTRL-W >` or `:vert res +1`: decrease window width

`CTRL-A`: increase number, e.g.: 1 -> 101 by 100 CTRL-A
`CTRL-X`: decrease number, e.g.: 101 -> 1 by 100 CTRL-X

`<Tab>=<C-I>`: jump forward
`CTRL-O`: jump backward

za: 打开或者关闭代码折叠

## 命令行模式常见操作

:au 显示所有 autocommand
:as 现实光标下字符的 ascii 码
:command  显示所有 command
:options 显示所有options
:aug 显示所有 au group
q: 打开 command line window
:marks 显示所有 marks
:me 菜单相关 没啥用 主要用于 vim 的 gui 
:find 查找文件并且编辑
:goto 跳转到第n字节
:grep 查找
:on 只保留当前window

## 搜索

开启搜索结果高亮

`set hlsearch`

临时关闭搜索结果高亮

`:nohl`

渐进式搜索

`set incsearch`

正则

1. BRE basic regular expression

BRE 元字符 meta characters:

`*^$.` `[] [^] [:space:]` `\{\}` `\(\)`


2. ERE extended regular expression

ERE 元字符 meta characters

`*^$.+?|` `[] [^]` `{}` `()`

3. GNU BRE

元字符

`*^$.\+\?\|` `[] [^]` `\{\}` `\(\)` `\b` `\w` `\s`

4. GNU ERE

元字符

`*^$.+?|` `[] [^]` `{}` `()` `\b` `\w` `\s`

5. vim 正则

vim `/` 和 `?` 的元字符

`* \+ \? \{n,m} \{,m} ^ $ . \< \> \s \d \x \w \a \l \u \t \r \(\) \1 [] \|`

这里尤为重要的是在 vim 的 buffer 中, 换行符是 \r

忽略大小写 `\c`

## 代码高亮显示

`syntax enable`

## 缩进

1. tab 替换成空格 

`set expandtab`

2. 设置缩进长度

`set shiftwidth=4 tabstop=4`

3. 自动缩进

`set autoindent` 通常ftplugin 会自动开启 `$VIMRUNTIME/`

自动缩进: 如果上面一行以 `{ ( [` 或者闭合的 > 结尾时 增加缩进


## 如何自定新建窗口的位置

vim 默认在上方和左边新建 window 可以通过修改

`set splitright splitbelow` 覆盖

下方: `:bel h` `:bel terminal`
水平: `:vert h terminal`


## 终端

1. 在下方打开终端

`:bel term`

2. 进入 terminal-mode: `i, I, a, A'

3. 返回 normal-mode `<C-\><C-N>`

3. 推荐键位设置

```vim
" use <C-\> open fixed height terminal
nn <C-\> :bel term<CR>:res 10<CR>:setlocal wfh<CR><CR>i
" easy move from terminal mode
tno <C-h> <C-\><C-n><C-w>h
tno <C-j> <C-\><C-n><C-w>j
tno <C-k> <C-\><C-n><C-w>k
tno <C-l> <C-\><C-n><C-w>l
tno <C-w>c <C-\><C-n><C-w>c
" easy terminal mode -> normal mode
tno <C-[> <C-\><C-n>
" open new terminal in terminal
tno <C-\> <C-\><C-n>:vert terminal<CR>i
```

## 多工作区

neovim/vim对多工作区的支持不是很好,建议通过tmux

## dap

建议新建 .vscode/launch.lua 然后设置快捷键执行
以 javascript debug 为例

.vscode/launch.lua

```lua
vim.schedule(function()
    dap.adapters['pwa-node'] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "/Users/salpt/bin/node",
            args = { vim.fn.expand("$HOME/bin/opt/js-debug/src/dapDebugServer.js"), "${port}" }
        }
    }

    dap.configurations.javascript =
    {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "bundle/main.js",
        cwd = "${workspaceFolder}",
    }
    dap.run(dap.configurations.javascript)
end)
```

然后 

```vim
luafile .vscode/launch.lua
````

lsp 安装:


1. microsoft/vscode-js-debug

```sh
wget -o ~/Downloads/js-debug.tgz 'https://github.com/microsoft/vscode-js-debug/releases/download/v1.91.0/js-debug-dap-v1.91.0.tar.gz'
mkdir -p ~/bin/opt
tar -xf ~/Downloads/js-debug.tgz -C ~/bin/opt
```

2. jdtls

see: https://github.com/mfussenegger/nvim-jdtls

```sh
wget -o ~/Downloads/jdtls.tgz 'https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz'
mkdir -p ~/bin/opt/jdtls
tar -xf ~/Downloads/jdtls.tgz -C ~/bin/opt/jdtls
```

3. java-debug

see: https://github.com/mfussenegger/nvim-jdtls

```sh
wget -o ~/Downloads/main.zip 'https://github.com/microsoft/java-debug/archive/refs/heads/main.zip'
unzip -d ~/opt/bin/java-debug ~/Downloads/main.zip 
```

```
print("hello world")
```
